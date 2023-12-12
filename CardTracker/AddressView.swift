//
//  AddressView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/11/23.
//

import SwiftUI

struct AddressView: View {
    var recipient: Recipient
    private var iPhone = false

    init(recipient: Recipient) {
        self.recipient = recipient
    }

    var body: some View {
        VStack(alignment: .leading) {
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
}
