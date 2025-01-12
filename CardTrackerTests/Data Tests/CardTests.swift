//
//  CardTests.swift
//  Greeting Tracker
//
//  Created by Michael Rowe1 on 1/12/25.
//


import XCTest
@testable import Greeting_Tracker

final class CardTests: XCTestCase {

    func testCardInitialization() {
        // Arrange
        let testDate = Date()
        let dummyImageData = UIImage(named: "frontImage")!.pngData()!
        let testEventType = EventType(eventName: "Birthday")
        let testCardFront = GreetingCard(cardName: "Happy Birthday Card", cardFront: dummyImageData, eventType: testEventType, cardManufacturer: "Hallmark", cardURL: "http://example.com")
        let testRecipient = Recipient(addressLine1: "", addressLine2: "", city: "", state: "", zip: "", country: "", firstName: "John", lastName: "Doe", category: .work)

        // Act
        let card = Card(cardDate: testDate, eventType: testEventType, cardFront: testCardFront, recipient: testRecipient)

        // Assert
        XCTAssertEqual(card.cardDate, testDate, "Card date should be initialized correctly.")
        XCTAssertEqual(card.eventType?.eventName, "Birthday", "Event type should be initialized correctly.")
        XCTAssertEqual(card.cardFront?.cardName, "Happy Birthday Card", "Card front should be initialized correctly.")
        XCTAssertEqual(card.recipient?.fullName, "John Doe", "Recipient should be initialized correctly.")
    }

    func testDebugDescription() {
        // Arrange
        let testDate = Date()
        let dummyImageData = UIImage(named: "frontImage")!.pngData()!
        let testEventType = EventType(eventName: "Anniversary")
        let testCardFront = GreetingCard(cardName: "Anniversary Card", cardFront: dummyImageData, eventType: testEventType, cardManufacturer: "Hallmark", cardURL: "http://example.com")
        let testRecipient = Recipient(addressLine1: "", addressLine2: "", city: "", state: "", zip: "", country: "", firstName: "Jane", lastName: "Smith", category: .work)
        let card = Card(cardDate: testDate, eventType: testEventType, cardFront: testCardFront, recipient: testRecipient)

        // Act
        let debugDescription = card.debugDescription

        // Assert
        let expectedDescription = "\(testDate), Anniversary, Anniversary Card, Jane Smith"
        XCTAssertEqual(debugDescription, expectedDescription, "Debug description should match expected format.")
    }
}
