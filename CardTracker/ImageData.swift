//
//  ImageData.swift
//  Greet Keeper
//
//  Created by Michael Rowe on 1/21/24.
//
/// ImageData Class:
///     The goal of this class is to allow for Async image load of Pictures

import Foundation
import SwiftUI

class ImageData: ObservableObject {
    @Published var uiImage: UIImage?
    
    var data: Data?
    
    init(data: Data?) {
        self.data = data
    }
    
    func loadImage() {
        DispatchQueue.global().async {
            if let data = self.data {
                if let uiImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.uiImage = uiImage
                    }
                }
            }
        }
    }
}
