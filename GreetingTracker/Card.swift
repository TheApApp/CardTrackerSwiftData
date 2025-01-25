//
//  Item.swift
//  GreetingTracker
//
//  Created by Michael Rowe on 12/10/23.
//

import Foundation
import SwiftData
import SwiftUI
import UIKit

/// A card is a specific instance of a greeting card sent to a specific person.

@Model
final class Card: CustomDebugStringConvertible {
    var debugDescription: String {
        "\(cardDate), \(eventType?.eventName ?? "Unknown event"), \(cardFront?.cardName ?? "No Card Name"), \(recipient?.fullName ?? "No Name")"
    }
    
    // MARK: Properties
    /// This can either be the date the card is sent or the date of the event the card is for.  By default all cards will start with today's date.
    var cardDate: Date = Date()
    /// A card must be attachd to a specific event type.  The event types are definable by the user of the application.
    var eventType: EventType? 
    /// A card will have an image, this is defined as a GreetingCard
    var cardFront: GreetingCard?
    /// A card must be sent to someone
    var recipient: Recipient?
    
    // MARK: - Initializer
    init(cardDate: Date, eventType: EventType, cardFront: GreetingCard, recipient: Recipient) {
        self.cardDate = cardDate
        self.eventType = eventType
        self.cardFront = cardFront
        self.recipient = recipient
    }
}
