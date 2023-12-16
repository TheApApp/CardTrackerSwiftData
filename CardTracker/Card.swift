//
//  Item.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/10/23.
//

import Foundation
import SwiftData
import UIKit

@Model
final class Card {
    var cardDate: Date = Date()
    var eventType: EventType? // @Relationship(deleteRule: .nullify, inverse: \EventType.cards) 
    @Attribute(.externalStorage) var cardFront: Data = (UIImage(named: "frontImage")?.pngData())!
    var recipient: Recipient?
    
    init(cardDate: Date, eventType: EventType, cardFront: Data, recipient: Recipient) {
        self.cardDate = cardDate
        self.eventType = eventType
        self.cardFront = cardFront
        self.recipient = recipient
    }
}
