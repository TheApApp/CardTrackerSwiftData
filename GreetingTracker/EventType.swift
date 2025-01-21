//
//  EventType.swift
//  GreetingTracker
//
//  Created by Michael Rowe on 12/10/23.
//

import Foundation
import SwiftData

///  EventType defines the name of various events for which you may wish to send a greeting card

@Model
final class EventType: CustomDebugStringConvertible {
    var debugDescription: String {
        "\(eventName)"
    }
    // MARK: Properties
    /// All eventtypes must have a descriptive name
    var eventName: String = ""
    /// Events are related to cards.  We have an array of cards which were created for this event.  We have an inverse relationship with the Cards
    @Relationship(deleteRule: .cascade, inverse: \Card.eventType) var cards: [Card]? = [Card]()
    @Relationship(deleteRule: .cascade, inverse: \GreetingCard.eventType) var greetingCards: [GreetingCard]? = [GreetingCard]()
    
    // MARK: - Initializer
    init(eventName: String) {
        self.eventName = eventName
    }
    
    // MARK: - Intents
    /// cardCount returns the number of Cards sent for this EventType
    func cardCount() -> Int {
        cards?.count ?? 0
    }
    
    /// galleryCount returns the number of Cards in the Gallery for this EventType
    func galleryCount() -> Int {
        greetingCards?.count ?? 0
    }
}
