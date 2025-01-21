//
//  EditRecipientView.swift
//  GreetingTracker
//
//  Created by Michael Rowe on 12/22/23.
//
// This looks like an abandoned view  Not called by any other view

/// Depreicated view.. replacing with Recipient View
/// 
import Contacts
import ContactsUI
import os
import SwiftData
import SwiftUI
import SwiftUIKit

struct EditRecipientView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    @Bindable var recipient: Recipient
    @Binding var navigationPath: NavigationPath // allows poping the edit for events
    
    @State private var presentAlert = false
    @State private var showPicker = false
    
    init(recipient: Bindable<Recipient>, navigationPath: Binding<NavigationPath>) {
        self._recipient = recipient
        self._navigationPath = navigationPath
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ContactPicker(showPicker: $showPicker, onSelectContact: {contact in
                    recipient.firstName = contact.givenName
                    recipient.lastName = contact.familyName
                    if contact.postalAddresses.count > 0 {
                        if let addressString = (
                            ((contact.postalAddresses[0] as AnyObject).value(forKey: "labelValuePair")
                             as AnyObject).value(forKey: "value"))
                            as? CNPostalAddress {
                            let mailAddress =
                                CNPostalAddressFormatter.string(from: addressString, style: .mailingAddress)
                            recipient.addressLine1 = "\(addressString.street)"
                            recipient.addressLine2 = ""
                            recipient.city = "\(addressString.city)"
                            recipient.state = "\(addressString.state)"
                            recipient.zip = "\(addressString.postalCode)"
                            recipient.country = "\(addressString.country)"
                            print("Mail address is \n\(mailAddress)")
                        }
                    } else {
                        recipient.addressLine1 = "No Address Provided"
                        recipient.addressLine2 = ""
                        recipient.city = ""
                        recipient.state = ""
                        recipient.zip = ""
                        recipient.country = ""
                        print("No Address Provided")
                    }
                    self.showPicker.toggle()
                }, onCancel: nil)
                VStack {
                    Text("")
                    Picker("Category", selection: $recipient.category) {
                            ForEach(Category.allCases) { category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .pickerStyle(SegmentedPickerStyle()) // You can also use DefaultPickerStyle()
                        
                    HStack {
                        VStack(alignment: .leading) {
                            TextField("First Name", text: $recipient.firstName)
                                .customTextField()
                        }
                        VStack(alignment: .leading) {
                            TextField("Last Name", text: $recipient.lastName)
                                .customTextField()
                        }
                    }
                    TextField("Address Line 1", text: $recipient.addressLine1)
                        .customTextField()
                    TextField("Address Line 2", text: $recipient.addressLine2)
                        .customTextField()
                    HStack {
                        TextField("City", text: $recipient.city)
                            .customTextField()
                            .frame(width: geo.size.width * 0.48)
                        Spacer()
                        TextField("ST", text: $recipient.state)
                            .customTextField()
                            .frame(width: geo.size.width * 0.18)
                        Spacer()
                        TextField("Zip", text: $recipient.zip)
                            .customTextField()
                            .frame(width: geo.size.width * 0.28)
                    }
                    TextField("Country", text: $recipient.country)
                        .customTextField()
                    Spacer()
                }
            }
            .padding([.leading, .trailing], 10 )
            .navigationTitle("Recipient Information")
            .navigationBarItems(trailing:
                                    HStack {
                Button(action: {
                    let contactsPermissions = checkContactsPermissions()
                    if contactsPermissions == true {
                        self.showPicker.toggle()
                    } else {
                        presentAlert = true
                    }
                }, label: {
                    Image(systemName: "person.crop.rectangle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.accentColor)
                })
                Button(action: {
                    do {
                        try modelContext.save()
                    } catch {
                        fatalError("Error saving changes: \(error)")
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "square.and.arrow.down")
                        .font(.largeTitle)
                        .foregroundColor(.accentColor)
                })
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
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
                    message: Text("Please enable access to contacs in Settings"),
                    dismissButton: .cancel()
                )
            })
        }
    }
    
    
    func checkContactsPermissions() -> Bool {
        // swiftlint:disable:next line_length
        let logger=Logger(subsystem: "com.theapapp.cardtracker", category: "NewRecipientView.checkContactsPermissions")
        let authStatus = CNContactStore.authorizationStatus(for: .contacts)
        switch authStatus {
        case .restricted:
            logger.log("User cannot grant permission, e.g. parental controls are in force.")
            return false
        case .denied:
            logger.log("User has denied permissions")
            return false
        case .notDetermined:
            logger.log("you need to request authorization via the API now")
        case .authorized:
            logger.log("already authorized")
        case .limited:
            logger.log("already limited authorized")
        @unknown default:
            logger.log("unknown error")
            return false
        }
        let store = CNContactStore()
        if authStatus == .notDetermined {
            store.requestAccess(for: .contacts) {success, error in
                if !success {
                    logger.log("Not authorized to access contacts. Error = \(String(describing: error))")
                    exit(1)
                }
                logger.log("Authorized")
            }
        }
        return true
    }
}
