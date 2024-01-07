//
//  NewRecipientView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/10/23.
//

import Contacts
import ContactsUI
import os
import SwiftData
import SwiftUI
import SwiftUIKit

struct NewRecipientView: View {
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
    
    @State var presentAlert = false
    @State var showPicker = false
    
    init() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.systemGreen,
            .font: UIFont(name: "ArialRoundedMTBold", size: 35)!]
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.systemGreen,
            .font: UIFont(name: "ArialRoundedMTBold", size: 20)!]
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ContactPicker(showPicker: $showPicker, onSelectContact: {contact in
                    firstName = contact.givenName
                    lastName = contact.familyName
                    if contact.postalAddresses.count > 0 {
                        if let addressString = (
                            ((contact.postalAddresses[0] as AnyObject).value(forKey: "labelValuePair")
                             as AnyObject).value(forKey: "value"))
                            as? CNPostalAddress {
                            let mailAddress =
                                CNPostalAddressFormatter.string(from: addressString, style: .mailingAddress)
                            addressLine1 = "\(addressString.street)"
                            addressLine2 = ""
                            city = "\(addressString.city)"
                            state = "\(addressString.state)"
                            zip = "\(addressString.postalCode)"
                            country = "\(addressString.country)"
                            print("Mail address is \n\(mailAddress)")
                        }
                    } else {
                        addressLine1 = "No Address Provided"
                        addressLine2 = ""
                        city = ""
                        state = ""
                        zip = ""
                        country = ""
                        print("No Address Provided")
                    }
                    self.showPicker.toggle()
                }, onCancel: nil)
                VStack {
                    Text("")
                    HStack {
                        VStack(alignment: .leading) {
                            TextField("First Name", text: $firstName)
                                .customTextField()
                        }
                        VStack(alignment: .leading) {
                            TextField("Last Name", text: $lastName)
                                .customTextField()
                        }
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
                    Image(systemName: "person.crop.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                })
                Button(action: {
                    saveRecipient()
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "square.and.arrow.down")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                })
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.down.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.green)
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
    
    func saveRecipient() {
        let logger=Logger(subsystem: "com.theapapp.cardtracker", category: "NewRecipientView.SaveRecipient")
        logger.log("Saving...")
        if firstName != "" {
            let recipient = Recipient(
                addressLine1: addressLine1.capitalized(with: NSLocale.current),
                addressLine2: addressLine2.capitalized(with: NSLocale.current),
                city: city.capitalized(with: NSLocale.current),
                state: state.uppercased(),
                zip: zip,
                country: country.capitalized(with: NSLocale.current),
                firstName: firstName,
                lastName: lastName)
            modelContext.insert(recipient)
        }
        do {
            try modelContext.save()
        } catch let error as NSError {
            logger.log("Save error: \(error), \(error.userInfo)")
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

#Preview {
    NewRecipientView()
}
