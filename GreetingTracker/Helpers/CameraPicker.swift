//
//  CameraPicker.swift
//  GreetingTracker
//
//  Created by Michael Rowe1 on 2/3/25.
//

import UIKit
import SwiftUI

#if !os(macOS) && !os(visionOS)
struct CameraPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?  // Use UIImage instead of Image
    @Environment(\.presentationMode) var presentationMode

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = false
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: CameraPicker

        init(_ parent: CameraPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                DispatchQueue.main.async {
                    self.parent.selectedImage = uiImage // Store UIImage directly
                    self.parent.presentationMode.wrappedValue.dismiss()
                }
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            DispatchQueue.main.async {
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
#endif
