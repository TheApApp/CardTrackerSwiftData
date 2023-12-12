//
//  ImageTransformer.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/11/23.
//

import Foundation
import UIKit

class ImageTransformer: ValueTransformer {

    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }

    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        autoreleasepool {
            guard let data = value as? Data else {
                return nil
            }

            return UIImage(data: data)
        }
    }

    override func transformedValue(_ value: Any?) -> Any? {
        autoreleasepool {
            guard let image = value as? UIImage else {
                return nil
            }

            return image.jpegData(compressionQuality: 0.75)
        }
    }

    public static func register() {
        let transformer = ImageTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: NSValueTransformerName(rawValue: "ImageTransformer"))
    }
}
