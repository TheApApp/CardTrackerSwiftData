//
//  GreetingCard.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/18/23.
//

import Foundation
import SwiftData
import UIKit

/// This is used to build a gallery of Greeting Cards

@Model
final class GreetingCard {
    ///     This is an optional String, you can use this to describe the card with a descriptive name
    var cardName: String?
    ///     This is the only required property.  An image of the front of the card must be supplied
    @Attribute(.externalStorage) var cardFront: Data?
    ///     This is the of event the Greeting Card is for
    var eventType: EventType?
    ///     This allows you to capture who sells the card. Companies like Hallmark, American Greetings, etc.
    var cardManufacturer: String?
    ///     A URL can be stored to allow fo identifying where you bought the card
    var cardURL: URL?
    ///     A greeting card will be used by various cards being sent.  We have an inverse relationship.
    @Relationship(deleteRule: .cascade, inverse: \Card.cardFront) var cards: [Card]? = []
    
    init(cardName: String?, cardFront: Data?, eventType: EventType?, cardManufacturer: String? = nil, cardURL: URL?) {
        /// When creating a new Greeting Card, you have to have an image, all other properties are optional.
        self.cardName = cardName
        self.cardFront = cardFront ?? UIImage(named: "frontImage")!.pngData()!
        self.eventType = eventType
        self.cardManufacturer = cardManufacturer
        self.cardURL = cardURL
    }
}
