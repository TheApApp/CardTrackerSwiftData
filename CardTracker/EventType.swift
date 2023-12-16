//
//  EventType.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/10/23.
//

import Foundation
import SwiftData

@Model
final class EventType {
    var eventName: String = ""
    @Relationship(deleteRule: .cascade, inverse: \Card.eventType) var cards: [Card]? = []
    
    init(eventName: String) {
        self.eventName = eventName
    }
}
