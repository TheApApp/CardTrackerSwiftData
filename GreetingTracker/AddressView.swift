//
//  AddressView.swift
//  GreetingTracker
//
//  Created by Michael Rowe on 12/11/23.
//

import SwiftUI

/// Address View presents the address information of a recipient in a visually appealing way.
/// This is used by both GeneratePDF and ViewRecipientDetailsView
struct AddressView: View {
    @Bindable  var recipient: Recipient
    @State private var navigationPath = NavigationPath()
    @State private var editRecipient = false
    
    init(recipient: Recipient) {
        self.recipient = recipient
    }
    
    var body: some View {
#if targetEnvironment(macCatalyst)
        VStack {
            RecipientAddressView(recipient: recipient)
                .foregroundColor(Color("AccentColor"))
                .scaledToFit()
            
            Button {
                editRecipient.toggle()
            } label: {
                Text("Edit")
                    .foregroundColor(Color("AccentColor"))
            }
            
            .fullScreenCover(isPresented: $editRecipient) {
                RecipientView(recipientToEdit: recipient)
                    .interactiveDismissDisabled(true)
            }
        }
#else
        RecipientAddressView(recipient: recipient)
            .foregroundColor(Color("AccentColor"))
            .scaledToFit()
            .contextMenu {
                Button {
                    editRecipient.toggle()
                } label: {
                    Text("Edit")
                        .foregroundColor(Color("AccentColor"))
                }
            }
            .fullScreenCover(isPresented: $editRecipient) {
                RecipientView(recipientToEdit: recipient)
                    .interactiveDismissDisabled(true)
            }
#endif
    }
}

#Preview {
    AddressView(recipient: Recipient(addressLine1: "123 North Street", addressLine2: "", city: "Anytown", state: "NC", zip: "12345-1234", country: "US", firstName: "Johnny", lastName: "Appleseed", category: .home))
}
