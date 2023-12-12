//
//  Recipient.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/10/23.
//

import Foundation
import SwiftData

@Model
final class Recipient {
    var addressLine1: String = ""
    var addressLine2: String = ""
    var city: String = ""
    var state: String = ""
    var zip: String = ""
    var country: String = ""
    var firstName: String = ""
    var lastName: String = ""
    @Relationship(deleteRule: .cascade, inverse: \Card.recipient) var cards: [Card]?
    
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
