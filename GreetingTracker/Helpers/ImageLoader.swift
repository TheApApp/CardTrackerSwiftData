//
//  ImageLoader.swift
//  Greet Keeper
//
//  Created by Michael Rowe on 3/23/24.
//

import Foundation
import SwiftUI

@MainActor
class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    func loadImage(from data: Data) {
        DispatchQueue.global().async { [weak self] in
            // Check if self still exists
            guard let self = self else { return }
            
            // Load image from data
            guard let uiImage = UIImage(data: data) else { return }
            
            // Update image property on the main queue
            DispatchQueue.main.async {
                self.image = uiImage
            }
        }
    }
}
