////
////  ContactPicker.swift
////  GreetingTracker
////
////  Created by Michael Rowe on 12/23/23.
////  Thanks to SharathTheGeek over at - https://sharaththegeek.substack.com/p/contactpicker-in-swiftui
//
//import SwiftUI
//import ContactsUI
//
///// ContactPicker is a UIViewControllerRepresentable struct, which means it represents a UIKit view controller in SwiftUI.
///// It has a binding isPresented to control the presentation of the contact picker.
///// There is a closure onSelect that will be called when a contact is selected.
///// The makeUIViewController function creates and configures a UINavigationController containing a CNContactPickerViewController. The delegate of the picker is set to an instance of the Coordinator class.
///// The updateUIViewController function is empty, as it doesn't need to update the UI during runtime.
///// The makeCoordinator function creates an instance of the Coordinator class.
///// A simple example of usage can be seen here:
/////
///// import SwiftUI
///// import Contacts
/////
///// struct ContentView: View {
/////    @State private var isContactPickerPresented = false
/////    @State private var selectedContact: CNContact?
/////
/////    var body: some View {
/////        VStack {
/////            Text("Selected Contact:")
/////            if let contact = selectedContact {
/////                Text("\(contact.givenName) \(contact.familyName)")
/////            } else {
/////                Text("None")
/////            }
/////
/////            Button("Select Contact") {
/////                isContactPickerPresented.toggle()
/////            }
/////            .contactPicker(isPresented: $isContactPickerPresented, onSelect: { contact in
/////                // Handle the selected contact
/////                selectedContact = contact
/////            })
/////        }
/////    }
///// }
//
//public struct ContactPicker: UIViewControllerRepresentable {
//    @Binding var isPresented: Bool
//    var onSelect: (CNContact) -> Void
//    public func makeUIViewController(context: Context) -> some UIViewController {
//        let navController = UINavigationController()
//        let pickerVC = CNContactPickerViewController()
//        pickerVC.delegate = context.coordinator
//        navController.pushViewController(pickerVC, animated: false)
//        navController.isNavigationBarHidden = true
//        return navController
//    }
//
//    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//
//    }
//  
//    public func makeCoordinator() -> Coordinator {
//        return Coordinator(parent: self)
//    }
//
//    /// Coordinator is a nested class within ContactPicker that conforms to CNContactPickerDelegate.
//    ///It has a reference to the parent ContactPicker instance and implements the delegate methods.
//    ///When a contact is selected (didSelect), it calls the onSelect closure provided in the parent ContactPicker.
//    public class Coordinator: NSObject, CNContactPickerDelegate {
//        var parent: ContactPicker
//        init(parent: ContactPicker) {
//            self.parent = parent
//        }
//
//        public func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
//
//        }
//
//        public func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
//            parent.onSelect(contact)
//        }
//    }
//}
//
///// ContactPickerViewModifier is a ViewModifier that can be applied to any SwiftUI view.
///// It has bindings for isPresented and a closure onDismiss that will be called when the sheet is dismissed.
///// The body function is implemented to wrap the provided content in a sheet. The sheet contains the ContactPicker with the specified bindings and closures.
//struct ContactPickerViewModifier: ViewModifier {
//    @Binding var isPresented: Bool
//    var onDismiss: (() -> Void)?
//    var onSelect: ((CNContact) -> Void)
//
//    func body(content: Content) -> some View {
//        content
//            .sheet(isPresented: $isPresented, onDismiss: onDismiss) {
//                ContactPicker(isPresented: $isPresented, onSelect: onSelect)
//            }
//    }
//}
//
///// An extension is provided for the View protocol, adding a function contactPicker that allows any SwiftUI view to use the contact picker.
///// This function takes isPresented as a binding for controlling the presentation, an optional onDismiss closure, and a required onSelect closure.
//public extension View {
//    func contactPicker(isPresented: Binding<Bool>, onDismiss: (() -> Void)?, onSelect: @escaping ((CNContact) -> Void)) -> some View {
//        modifier(ContactPickerViewModifier(isPresented: isPresented, onDismiss: onDismiss, onSelect: onSelect))
//    }
//}
