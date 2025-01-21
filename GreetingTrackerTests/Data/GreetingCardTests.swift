//
//  GreetingCardTests.swift
//  Greeting Tracker
//
//  Created by Michael Rowe1 on 1/12/25.
//


import XCTest
@testable import GreetingTracker

final class GreetingCardTests: XCTestCase {
    
    func testInitializationWithNameAndManufacturer() {
        let card = GreetingCard(cardName: "Birthday Card", cardFront: nil, cardManufacturer: "Hallmark", cardURL: "http://example.com")
        
        XCTAssertEqual(card.cardName, "Birthday Card")
        XCTAssertEqual(card.cardManufacturer, "Hallmark")
        XCTAssertEqual(card.cardURL, "http://example.com")
        XCTAssertNotNil(card.cardFront)  // Assuming it has a default front image
        XCTAssertEqual(card.eventType, nil)
    }
    
    func testInitializationWithCompleteData() {
        let dummyImageData = UIImage(named: "frontImage")!.pngData()!
        let event = EventType(eventName: "Birthday")
        let card = GreetingCard(cardName: "Birthday Card", cardFront: dummyImageData, eventType: event, cardManufacturer: "Hallmark", cardURL: "http://example.com")
        
        XCTAssertEqual(card.cardName, "Birthday Card")
        XCTAssertEqual(card.cardManufacturer, "Hallmark")
        XCTAssertEqual(card.cardURL, "http://example.com")
        XCTAssertEqual(card.eventType?.eventName, "Birthday")
        XCTAssertEqual(card.cardFront, dummyImageData)
    }
    
    func testDebugDescription() {
        let dummyImageData = UIImage(named: "frontImage")!.pngData()!
        let event = EventType(eventName: "Birthday")
        let card = GreetingCard(cardName: "Birthday Card", cardFront: dummyImageData, eventType: event, cardManufacturer: "Hallmark", cardURL: "http://example.com")
        
        XCTAssertEqual(card.debugDescription, "Birthday Card, Birthday, Hallmark, http://example.com, Used - 0")
    }
    
    func testCardDescriptionWithEvent() {
        let dummyImageData = UIImage(named: "frontImage")!.pngData()!
        let event = EventType(eventName: "Birthday")
        let card = GreetingCard(cardName: "Birthday Card", cardFront: dummyImageData, eventType: event, cardManufacturer: "Hallmark", cardURL: "http://example.com")
        
        XCTAssertEqual(card.debugDescription, "Birthday Card, Birthday, Hallmark, http://example.com, Used - 0")
    }
}
