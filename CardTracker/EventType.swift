//
//  EventType.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/10/23.
//

import Foundation
import SwiftData

///  EventType defines the name of various events for which you may wish to send a greeting card

@Model
final class EventType {
    /// All eventtypes must have a descriptive name
    var eventName: String = ""
    /// Events are related to cards.  We have an array of cards which were created for this event.  We have an inverse relationship with the Cards
    @Relationship(deleteRule: .cascade, inverse: \Card.eventType) var cards: [Card]? = []
    @Relationship(deleteRule: .nullify, inverse: \GreetingCard.eventType) var greetingCards: [GreetingCard]? = []
    
    init(eventName: String) {
        self.eventName = eventName
    }
}
