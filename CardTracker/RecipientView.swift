//
//  RecipientFormView.swift
//  Greet Keeper
//
//  Created by Michael Rowe1 on 12/28/24.
//


import Contacts
import ContactsUI
import os
import SwiftData
import SwiftUI
import SwiftUIKit

struct RecipientView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode

    @State private var lastName: String = ""
    @State private var firstName: String = ""
    @State private var addressLine1: String = ""
    @State private var addressLine2: String = ""
    @State private var city: String = ""
    @State private var state: String = ""
    @State private var zip: String = ""
    @State private var country: String = ""
    @State private var selectedCategory: Category = .home

    @State private var presentAlert = false
    @State private var showPicker = false

    let recipientToEdit: Recipient?

    init(recipientToEdit: Recipient? = nil) {
        self.recipientToEdit = recipientToEdit
        if let recipient = recipientToEdit {
            _firstName = State(initialValue: recipient.firstName)
            _lastName = State(initialValue: recipient.lastName)
            _addressLine1 = State(initialValue: recipient.addressLine1)
            _addressLine2 = State(initialValue: recipient.addressLine2)
            _city = State(initialValue: recipient.city)
            _state = State(initialValue: recipient.state)
            _zip = State(initialValue: recipient.zip)
            _country = State(initialValue: recipient.country)
            _selectedCategory = State(initialValue: recipient.category ?? .home)
        }
    }

    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(Category.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    HStack {
                        TextField("First Name", text: $firstName)
                            .customTextField()
                        TextField("Last Name", text: $lastName)
                            .customTextField()
                    }

                    TextField("Address Line 1", text: $addressLine1)
                        .customTextField()
                    TextField("Address Line 2", text: $addressLine2)
                        .customTextField()

                    HStack {
                        TextField("City", text: $city)
                            .customTextField()
                            .frame(width: geo.size.width * 0.48)
                        Spacer()
                        TextField("ST", text: $state)
                            .customTextField()
                            .frame(width: geo.size.width * 0.18)
                        Spacer()
                        TextField("Zip", text: $zip)
                            .customTextField()
                            .frame(width: geo.size.width * 0.28)
                    }

                    TextField("Country", text: $country)
                        .customTextField()

                    Spacer()

                    Button(action: {
                        let contactsPermissions = checkContactsPermissions()
                        if contactsPermissions {
                            showPicker.toggle()
                        } else {
                            presentAlert = true
                        }
                    }, label: {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.accentColor)
                    })
                }
                .padding([.leading, .trailing], 10)
                .navigationTitle(recipientToEdit == nil ? "New Recipient" : "Edit Recipient")
                .navigationBarItems(trailing:
                    HStack {
                        Button(action: {
                            saveRecipient()
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "square.and.arrow.down")
                                .font(.largeTitle)
                                .foregroundColor(.accentColor)
                        })
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "chevron.down.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.accentColor)
                        })
                    }
                )
                .alert(isPresented: $presentAlert, content: {
                    Alert(
                        title: Text("Contacts Denied"),
                        message: Text("Please enable access to contacts in Settings"),
                        dismissButton: .cancel()
                    )
                })
            }
        }
    }

    func saveRecipient() {
        let logger = Logger(subsystem: "com.theapapp.cardtracker", category: "RecipientFormView.SaveRecipient")
        logger.log("Saving...")

        if firstName.isEmpty && lastName.isEmpty {
            return
        }

        if let recipient = recipientToEdit {
            recipient.firstName = firstName
            recipient.lastName = lastName
            recipient.addressLine1 = addressLine1
            recipient.addressLine2 = addressLine2
            recipient.city = city
            recipient.state = state
            recipient.zip = zip
            recipient.country = country
            recipient.category = selectedCategory
        } else {
            let newRecipient = Recipient(
                addressLine1: addressLine1.capitalized(with: NSLocale.current),
                addressLine2: addressLine2.capitalized(with: NSLocale.current),
                city: city.capitalized(with: NSLocale.current),
                state: state.uppercased(),
                zip: zip,
                country: country.capitalized(with: NSLocale.current),
                firstName: firstName,
                lastName: lastName,
                category: selectedCategory
            )
            modelContext.insert(newRecipient)
        }

        do {
            try modelContext.save()
        } catch let error as NSError {
            logger.log("Save error: \(error), \(error.userInfo)")
        }
    }

    func checkContactsPermissions() -> Bool {
        let logger = Logger(subsystem: "com.theapapp.cardtracker", category: "RecipientFormView.checkContactsPermissions")
        let authStatus = CNContactStore.authorizationStatus(for: .contacts)

        switch authStatus {
        case .restricted, .denied:
            logger.log("Permission denied or restricted")
            return false
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { success, error in
                if !success {
                    logger.log("Access denied: \(String(describing: error))")
                }
            }
            return false
        case .authorized:
            logger.log("Permission granted")
            return true
        case .limited:
            logger.log("Limited Permission")
            return true
        @unknown default:
            logger.log("Unknown authorization status")
            return false
        }
    }
}
