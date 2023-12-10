//
//  Event.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/10/23.
//

import Foundation
import SwiftData

@Model
final class Event {
    var id: UUID
    var eventName: String
    
    init(eventName: String) {
        self.id = UUID()
        self.eventName = eventName
    }
    
}
