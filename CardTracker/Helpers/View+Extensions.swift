//
//  View+Extensions.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/11/23.
//

import SwiftUI

extension View {
    /// This function changes our View to UIView, then calls another function
    /// to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)

        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        windowScene?.windows.first!.rootViewController?.view.addSubview(controller.view)

        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()

        // here is the call to the function that converts UIView to UIImage: `.asImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}
