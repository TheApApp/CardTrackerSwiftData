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
    private var iPhone = false

    init(imageData: Data?) {
        self.imageData = imageData
        
        if UIDevice.current.userInterfaceIdiom == .phone || UIDevice.current.userInterfaceIdiom == .vision {
            iPhone = true
        }
    }
    var body: some View {
        if let imageData = imageData, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaledToFit()
//                .frame(width: iPhone ? 125 : 250, height: iPhone ? 125 : 250)
            
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

