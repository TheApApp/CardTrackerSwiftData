//
//  ImageLoader.swift
//  Greet Keeper
//
//  Created by Michael Rowe on 3/23/24.
//

import Foundation
import SwiftUI

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    func loadImage(from data: Data) {
        DispatchQueue.global().async { [weak self] in
            guard let uiImage = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.image = uiImage
            }
        }
    }
}
