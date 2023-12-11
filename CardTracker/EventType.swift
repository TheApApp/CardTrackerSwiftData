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
    var eventName: String = "Unknown"
    var card: Card?
    
    init(eventName: String) {
        self.eventName = eventName
    }
    
}
