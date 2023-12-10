//
//  Item.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/10/23.
//

import Foundation
import SwiftData

@Model
final class Card {
    var id: UUID
    var cardDate: Date
    var eventType: Event
    @Attribute(.externalStorage, .allowsCloudEncryption) var cardFront: Data
    var recipient: Recipient
    
    init(cardDate: Date, eventType: Event, cardFront: Data, recipient: Recipient) {
        self.id = UUID()
        self.cardDate = cardDate
        self.eventType = eventType
        self.cardFront = cardFront
        self.recipient = recipient
    }
}
