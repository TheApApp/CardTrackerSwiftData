//
//  EventTypeTests.swift
//  Greeting Tracker
//
//  Created by Michael Rowe1 on 1/12/25.
//

import SwiftUI
import Testing
@testable import CardTracker

struct EventTypeTests {
    let eventName = "Birthday"
    let eventType = EventType(eventName: "Birthday")
    
    @Test("Test Initializing")
    func testInitialization() {
        #expect(eventType.eventName == eventName, "Event name should be initialized correctly.")
        #expect(eventType.cards == [], "Cards array should be initialized as an empty array.")
        #expect(eventType.greetingCards == [], "GreetingCards array should be initialized as an empty array.")
        #expect(eventType.cards?.count == 0, "Cards array should initially be empty.")
        #expect(eventType.greetingCards?.count == 0, "GreetingCards array should initially be empty.")
    }

    @Test("Test Debug Description")
    func testDebugDescription() {
        let eventName = "Birthday"
        let eventType = EventType(eventName: eventName)
        let debugDescription = eventType.debugDescription

        // Assert
        #expect(debugDescription == eventName, "Debug description should match the event name.")
    }

    @Test("Test Card Count")
    func testCardCount() {
        // Arrange
        let eventType = EventType(eventName: "Holiday")
        let card1 = Card(cardDate: Date(), eventType: eventType, cardFront: GreetingCard(cardName: "Card 1", cardFront: nil, cardManufacturer: "Card 1 Manufacturer", cardURL: "Card 1 URL"), recipient: Recipient(addressLine1: "Address Line 1", addressLine2: "Address Line 2", city: "Address City", state: "AA", zip: "12345", country: "US", firstName: "First Name", lastName: "Last Name", category: Category.home))
        let card2 = Card(cardDate: Date(), eventType: eventType, cardFront: GreetingCard(cardName: "Card 2", cardFront: nil, cardManufacturer: "Card 2 Manufacturer", cardURL: "Card 2 URL"), recipient: Recipient(addressLine1: "Address Line 1", addressLine2: "Address Line 2", city: "Address City", state: "AA", zip: "12345", country: "US", firstName: "First Name", lastName: "Last Name", category: Category.home))

        eventType.cards = [card1, card2]

        // Act
        let count = eventType.cardCount()

        // Assert
        #expect(count == 2, "Card count should match the number of cards associated with the event.")
    }

    @Test("Test Gallery Count")
    func testGalleryCount() {
        // Arrange
        let eventType = EventType(eventName: "Wedding")
        let dummyImageData = UIImage(named: "frontImage")!.pngData()!
        let greetingCard1 = GreetingCard(cardName: "Wedding Card 1", cardFront: dummyImageData, eventType: eventType, cardManufacturer: "Hallmark", cardURL: "http://example.com")
        let greetingCard2 = GreetingCard(cardName: "Wedding Card 2", cardFront: dummyImageData, eventType: eventType, cardManufacturer: "Hallmark", cardURL: "http://example.com")

        eventType.greetingCards = [greetingCard1, greetingCard2]

        // Act
        let count = eventType.galleryCount()

        // Assert
        #expect(count == 2, "Gallery count should match the number of greeting cards associated with the event.")
    }
}
