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
    @Relationship(deleteRule: .nullify, inverse: \EventType.card) var eventName: EventType?
    @Attribute(.externalStorage) var cardFront: Data = (UIImage(named: "frontImage")?.pngData())!
    var recipient: Recipient?
    
    init(cardDate: Date, eventName: EventType, cardFront: Data, recipient: Recipient) {
        self.cardDate = cardDate
        self.eventName = eventName
        self.cardFront = cardFront
        self.recipient = recipient
    }
}
