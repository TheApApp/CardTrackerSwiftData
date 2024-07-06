//
//  TextFieldModifier.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/10/23.
//

import SwiftUI

/// A simple ViewModifier to adjust the way content is displayed in a TextField.  The application uses this to provide a consistent design language for all Text Fields.
struct TextFieldModifier: ViewModifier {
    let borderWidth: CGFloat = 1.0

    func body(content: Content) -> some View {
        content
            .padding(10)
            .font(Font.system(size: 20, weight: .medium, design: .rounded))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.accentColor, lineWidth: borderWidth))
    }
}

/// This View extension allows for assigning the TextFieldModifer to textFields in SwiftUI
extension View {
    func customTextField() -> some View {
        self.modifier(TextFieldModifier())
    }
}
