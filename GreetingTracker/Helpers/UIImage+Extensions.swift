//
//  UIImage+Extensions.swift
//  GreetingTracker
//
//  Created by Michael Rowe on 12/11/23.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

extension UIImage {
    
    /// This method resizes the image by a given percentage. It calculates the new size based on the percentage provided,
    /// creates a new graphics context, draws the image into that context with the new size, and returns the resulting UIImage.
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// This method resizes the image to a specific width while maintaining the aspect ratio.
    /// It calculates the new height based on the original aspect ratio, creates a new graphics context,
    /// draws the image into that context with the new size, and returns the resulting UIImage.
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    ///  This method fixes the orientation of the image. Images can have different orientations
    ///  (up, down, left, right), and this method ensures that the image is in the "up" orientation.
    ///  It creates a new graphics context, draws the image into that context, and returns the normalized UIImage.
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }

    /// This method compresses the image to meet a specified maximum byte size. It uses a loop to iteratively compress the image with decreasing compression quality until the image size is below the specified maximum byte size. The completion closure is called with the compressed image data.
    ///
    /// It starts with full compression quality (1.0) and decreases the quality by 0.1 in each iteration.
    ///
    /// The loop continues until the image size is below the maximum byte size.
    ///
    /// The compressed image data is then passed to the completion closure.
    ///
    /// Note: The defer keyword is used to ensure that UIGraphicsEndImageContext() is always called, even if an error occurs or the method returns early.
    /// This is important to avoid memory leaks associated with the image context.
    func resizeByByte(maxByte: Int, completion: @escaping (Data) -> Void) {
        var compressQuality: CGFloat = 1
        var imageData = Data()
        var imageByte = self.jpegData(compressionQuality: 1)?.count

        while imageByte! > maxByte {
            imageData = self.jpegData(compressionQuality: compressQuality)!
            imageByte = self.jpegData(compressionQuality: compressQuality)?.count
            compressQuality -= 0.1
        }

        if maxByte > imageByte! {
            completion(imageData)
        } else {
            completion(self.jpegData(compressionQuality: 1)!)
        }
    }

    /// This enum defines a set of multipliers for the Quality of a JPEG image
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged,
    /// calling this function forces that data to be reloaded into memory.
    ///
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data.
    /// This function may return nil if the image has no data or if the underlying CGImageRef contains data in an
    /// unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
