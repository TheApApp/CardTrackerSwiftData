//
//  RecipientAddressView.swift
//  GreetingTracker
//
//  Created by Michael Rowe1 on 1/21/25.
//
import SwiftUI

struct RecipientAddressView: View {
    let recipient: Recipient
    
    var body: some View {
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
        .foregroundColor(.accentColor)
        .padding([.leading, .trailing], 10 )
    }
}

#Preview {
    let recipient = Recipient(addressLine1: "123 North Street", addressLine2: "", city: "Anytown", state: "NY", zip: "12345", country: "US", firstName: "Johnny", lastName: "Appleseed", category: Category.home)
        RecipientAddressView(recipient: recipient)
}
