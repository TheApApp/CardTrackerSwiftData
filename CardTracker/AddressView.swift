//
//  AddressView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/11/23.
//

import SwiftUI

/// Address View presents the address information of a recipient in a visually appealing way.
/// This is used by both GeneratePDF and ViewEventsView
struct AddressView: View {
    @Bindable  var recipient: Recipient
    @State private var navigationPath = NavigationPath()
    @State private var editRecipient = false

    init(recipient: Recipient) {
        self.recipient = recipient
    }

    var body: some View {
        Menu {
            Button("Edit") {
                editRecipient.toggle()
            }
        } label: {
            VStack(alignment: .leading) {
                Text("\(recipient.category?.rawValue.capitalized ?? "Home")")
                Text("\(recipient.firstName) \(recipient.lastName)")
                if !recipient.addressLine1.isEmpty {
                    Text(recipient.addressLine1)
                }
                if !recipient.addressLine2.isEmpty {
                    Text(recipient.addressLine2)
                }
                let cityLine =
                String("\(recipient.city), \(recipient.state) \(recipient.zip)")
                if cityLine != ",  " {
                    Text(cityLine)
                }
                
                if !recipient.country.isEmpty {
                    Text(recipient.country).textCase(.uppercase)
                }
            }
            .scaledToFit()
            .foregroundColor(.accentColor)
            .padding([.leading, .trailing], 10 )
        }
        .sheet(isPresented: $editRecipient) {
            RecipientView(recipientToEdit: recipient)
                .interactiveDismissDisabled(true)
        }
    }
}

#Preview {
    AddressView(recipient: Recipient(addressLine1: "123 North Street", addressLine2: "", city: "Anytown", state: "NC", zip: "12345-1234", country: "US", firstName: "Johnny", lastName: "Appleseed", category: .home))
}
