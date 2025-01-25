//
//  AsyncImageView.swift
//  Greet Keeper
//
//  Created by Michael Rowe on 3/23/24.
//

import SwiftUI

struct AsyncImageView: View {
    @StateObject private var imageLoader = ImageLoader()
    let imageData: Data?

    init(imageData: Data?) {
        self.imageData = imageData
    }
    
    var body: some View {
        #if DEBUG
        let _ = print("AsyncImageView rendered: \(String(describing: imageData))")
        #endif
        if let imageData = imageData, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaledToFit()
        } else {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .onAppear {
                    if let imageData = imageData {
                        imageLoader.loadImage(from: imageData)
                    }
                }
        }
    }
}

#Preview {
    if let defaultImage = UIImage(named: "frontImage"),
       let imageData = defaultImage.pngData() {
        AsyncImageView(imageData: imageData)
    } else {
        AsyncImageView(imageData: nil) // Fallback if the asset isn't available
    }
}
