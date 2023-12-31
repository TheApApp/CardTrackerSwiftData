//
//  AddressView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/11/23.
//

import SwiftUI

/// Address View presents the address information of a recipient in a visually appealing way.
struct AddressView: View {
    var recipient: Recipient

    init(recipient: Recipient) {
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
        .foregroundColor(.green)
        .padding([.leading, .trailing], 10 )
    }
}
