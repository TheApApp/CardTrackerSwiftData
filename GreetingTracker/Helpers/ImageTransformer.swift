//
//  ImageTransformer.swift
//  GreetingTracker
//
//  Created by Michael Rowe on 12/11/23.
//

import Foundation
import UIKit

/// This Swift class, ImageTransformer, is a subclass of ValueTransformer, which is part of the Foundation framework. 
/// ValueTransformer is used for transforming values between different representations, making it useful for converting data types or formats. In this case,
/// ImageTransformer is designed to convert between UIImage and Data. (Source ChatGPT Code explaination)
/// The class ImageTransformer is declared as a subclass of ValueTransformer. This means it inherits properties and behaviors from the ValueTransformer class.
class ImageTransformer: ValueTransformer {

    /// This method overrides the transformedValueClass method of ValueTransformer. 
    /// It indicates the expected class of the transformed value. In this case, it suggests that the transformed value will be of type NSData (Foundation class for handling raw data).
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }

    /// This method overrides allowsReverseTransformation and returns true, indicating that reverse transformations are allowed. 
    /// In other words, this transformer can convert both from UIImage to Data and vice versa.
    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    /// This method performs the reverse transformation, converting a value of type Data to a UIImage. 
    /// It uses an autoreleasepool to manage memory more efficiently. If the provided value is not of type Data, it returns nil.
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        autoreleasepool {
            guard let data = value as? Data else {
                return nil
            }

            return UIImage(data: data)
        }
    }

    /// This method performs the forward transformation, converting a value of type UIImage to Data. 
    /// It uses an autoreleasepool and checks if the provided value is a UIImage.
    /// If so, it converts the image to JPEG data with a compression quality of 0.75 and returns the result.
    override func transformedValue(_ value: Any?) -> Any? {
        autoreleasepool {
            guard let image = value as? UIImage else {
                return nil
            }

            return image.jpegData(compressionQuality: 0.75)
        }
    }

    /// This method creates an instance of ImageTransformer, then registers it with the system using ValueTransformer.setValueTransformer. 
    /// It associates the transformer with the name "ImageTransformer," allowing it to be easily identified and used when needed.
    public static func register() {
        let transformer = ImageTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: NSValueTransformerName(rawValue: "ImageTransformer"))
    }
}
