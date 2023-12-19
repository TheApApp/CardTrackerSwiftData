//
//  Recipient.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/10/23.
//

import Foundation
import SwiftData

/// A recipient is someone you have sent a card to.  It is the primary view for the application.  A recipient must have a name.
@Model
final class Recipient {
    /// When sending a card, a recipient should have an address.  This is the first line, usually the street address.
    var addressLine1: String = ""
    /// This is the second line, usually the apartment or unit number.
    var addressLine2: String = ""
    /// This is the city of town for the address.
    var city: String = ""
    /// This is the state or region for the address.
    var state: String = ""
    /// This is the Zip or Postal code for the address.
    var zip: String = ""
    /// This is the Country
    var country: String = ""
    /// This is the First Name (or names) of the recipient of the card
    var firstName: String = ""
    /// This is the Last Name of the recipient of the card
    var lastName: String = ""
    /// A Recipient may have zero or more cards. There is a cascading relationship to the cards
    @Relationship(deleteRule: .cascade, inverse: \Card.recipient) var cards: [Card]?
    
    /// This is a computed promperty holidng the full name of the recipient, it is first name followed by a space and then the last name
    var fullName: String {
        String("\(firstName) \(lastName)")
    }
        
    init(addressLine1: String, addressLine2: String, city: String, state: String, zip: String, country: String, firstName: String, lastName: String) {
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        self.city = city
        self.state = state
        self.zip = zip
        self.country = country
        self.firstName = firstName
        self.lastName = lastName
    }
}
