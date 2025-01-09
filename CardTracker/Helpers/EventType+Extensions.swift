//
//  EventType+Extensions.swift
//  Greeting Tracker
//
//  Created by Michael Rowe1 on 1/9/25.
//

import Foundation
import SwiftUI

extension EventType {
    static var mockData: [EventType] {
        [
            EventType(eventName: "Birthday"),
            EventType(eventName: "Anniversary"),
            EventType(eventName: "Wedding"),
            EventType(eventName: "Graduation"),
            EventType(eventName: "New Year"),
        ]
    }
}

#Preview {
    List(EventType.mockData, id: \.eventName) { eventType in
        Text(eventType.eventName)
    }
}
