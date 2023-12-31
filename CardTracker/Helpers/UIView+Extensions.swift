//
//  UIView+Extensions.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/11/23.
//

import SwiftUI

extension UIView {
    /// This function extends the UIView to allow for conversion of UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
