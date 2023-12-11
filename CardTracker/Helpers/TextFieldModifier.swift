//
//  TextFieldModifier.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/10/23.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    let borderWidth: CGFloat = 1.0

    func body(content: Content) -> some View {
        content
            .padding(10)
            .font(Font.system(size: 20, weight: .medium, design: .rounded))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: borderWidth))
    }
}

extension View {
    func customTextField() -> some View {
        self.modifier(TextFieldModifier())
    }
}
