//
//  ImageCompressor.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/11/23.
//

import UIKit

/// ImageCompressor struct provides a method to iteratively compress a UIImage while adjusting the compression quality to meet a specified maximum size requirement. The process is performed asynchronously on a background queue, and the result is returned via a completion closure.

struct ImageCompressor {
    
    /// This is a static method that takes three parameters:
    /// image: The input UIImage that needs to be compressed.
    /// maxByte: The maximum allowable size for the compressed image in bytes.
    /// completion: A closure that will be called when the compression is complete, passing the resulting compressed UIImage or nil if an error occurs.
    static func compress(image: UIImage, maxByte: Int,
                         completion: @Sendable @MainActor @escaping (UIImage?) -> Void) {
        MainActor.assumeIsolated {
            guard let currentImageSize = image.jpegData(compressionQuality: 1.0)?.count else {
                return completion(nil)
            }

            var iterationImage: UIImage? = image
            var iterationImageSize = currentImageSize
            var iterationCompression: CGFloat = 1.0

            while iterationImageSize > maxByte && iterationCompression > 0.01 {
                let percentageDecrease: CGFloat
                                switch iterationImageSize {
                                case 0..<3000000: percentageDecrease = 0.05
                                case 3000000..<10000000: percentageDecrease = 0.1
                                default: percentageDecrease = 0.2
                                }

                let canvasSize = CGSize(width: image.size.width * iterationCompression,
                                        height: image.size.height * iterationCompression)
                UIGraphicsBeginImageContextWithOptions(canvasSize, false, image.scale)
                defer { UIGraphicsEndImageContext() }
                image.draw(in: CGRect(origin: .zero, size: canvasSize))
                iterationImage = UIGraphicsGetImageFromCurrentImageContext()

                guard let newImageSize = iterationImage?.jpegData(compressionQuality: 1.0)?.count else {
                    return completion(nil)
                }
                iterationImageSize = newImageSize
                iterationCompression -= percentageDecrease
            }
            completion(iterationImage)
        }
    }
}
