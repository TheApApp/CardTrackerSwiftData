//
//  CardTests.swift
//  Greeting Tracker
//
//  Created by Michael Rowe1 on 1/12/25.
//

import Foundation
import SwiftUI
import Testing
@testable import GreetingTracker

struct CardTests {
    let testDate = Date()
    let testEventType = EventType(eventName: "Birthday")
    let testCardFront = GreetingCard(cardName: "Happy Birthday Card", cardFront: UIImage(named: "frontImage")!.pngData()!, eventType: EventType(eventName: "Birthday"), cardManufacturer: "Hallmark", cardURL: "http://example.com")
    let testRecipient = Recipient(addressLine1: "", addressLine2: "", city: "", state: "", zip: "", country: "", firstName: "John", lastName: "Doe", category: .work)
    
    @Test("Testing Card Initialization")
    func testCardInitialization() {
        let card = Card(cardDate: testDate, eventType: testEventType, cardFront: testCardFront, recipient: testRecipient)
        
        // Assert
        #expect(card.cardDate == testDate, "Card date should be initialized correctly.")
        #expect(card.eventType?.eventName == "Birthday", "Event type should be initialized correctly.")
        #expect(card.cardFront?.cardName == "Happy Birthday Card", "Card front should be initialized correctly.")
        #expect(card.recipient?.fullName == "John Doe", "Recipient should be initialized correctly.")
    }
    
    @Test("Test Card Description")
    func testDebugDescription() {
        let card = Card(cardDate: testDate, eventType: testEventType, cardFront: testCardFront, recipient: testRecipient)
        let debugDescription = card.debugDescription
        
        let expectedDescription = "\(testDate), Birthday, Happy Birthday Card, John Doe"
        #expect(debugDescription == expectedDescription, "Debug description should match expected format.")
    }
}
