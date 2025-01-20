//
//  RecipientTests.swift
//  Greeting Tracker
//
//  Created by Michael Rowe1 on 1/12/25.
//


import XCTest
@testable import CardTracker

final class RecipientTests: XCTestCase {

    func testInitialization() {
        // Arrange
        let addressLine1 = "123 Main St"
        let addressLine2 = "Apt 4B"
        let city = "Springfield"
        let state = "IL"
        let zip = "62704"
        let country = "USA"
        let firstName = "John"
        let lastName = "Doe"
        let category = Category.home

        // Act
        let recipient = Recipient(addressLine1: addressLine1, addressLine2: addressLine2, city: city, state: state, zip: zip, country: country, firstName: firstName, lastName: lastName, category: category)

        // Assert
        XCTAssertEqual(recipient.addressLine1, addressLine1, "Address Line 1 should be initialized correctly.")
        XCTAssertEqual(recipient.addressLine2, addressLine2, "Address Line 2 should be initialized correctly.")
        XCTAssertEqual(recipient.city, city, "City should be initialized correctly.")
        XCTAssertEqual(recipient.state, state, "State should be initialized correctly.")
        XCTAssertEqual(recipient.zip, zip, "Zip should be initialized correctly.")
        XCTAssertEqual(recipient.country, country, "Country should be initialized correctly.")
        XCTAssertEqual(recipient.firstName, firstName, "First Name should be initialized correctly.")
        XCTAssertEqual(recipient.lastName, lastName, "Last Name should be initialized correctly.")
        XCTAssertEqual(recipient.category, category, "Category should be initialized correctly.")
    }

    func testFullName() {
        // Arrange
        let recipient = Recipient(addressLine1: "", addressLine2: "", city: "", state: "", zip: "", country: "", firstName: "Jane", lastName: "Smith", category: .work)

        // Act
        let fullName = recipient.fullName

        // Assert
        XCTAssertEqual(fullName, "Jane Smith", "Full name should be a combination of first and last name.")
    }

    func testCardsSent() {
        // Arrange
        let recipient = Recipient(addressLine1: "", addressLine2: "", city: "", state: "", zip: "", country: "", firstName: "Jane", lastName: "Smith", category: .work)
        let card1 = Card(cardDate: Date(), eventType: EventType(eventName: "Test 1"), cardFront: GreetingCard(cardName: "Card 1", cardFront: nil, cardManufacturer: "Card 1 Manufacturer", cardURL: "Card 1 URL"), recipient: Recipient(addressLine1: "Address Line 1", addressLine2: "Address Line 2", city: "Address City", state: "AA", zip: "12345", country: "US", firstName: "First Name", lastName: "Last Name", category: Category.home))
        let card2 = Card(cardDate: Date(), eventType: EventType(eventName: "Test 2"), cardFront: GreetingCard(cardName: "Card 2", cardFront: nil, cardManufacturer: "Card 2 Manufacturer", cardURL: "Card 2 URL"), recipient: Recipient(addressLine1: "Address Line 1", addressLine2: "Address Line 2", city: "Address City", state: "AA", zip: "12345", country: "US", firstName: "First Name", lastName: "Last Name", category: Category.home))

        recipient.cards = [card1, card2]

        // Act
        let cardsSent = recipient.cardsSent()

        // Assert
        XCTAssertEqual(cardsSent, 2, "cardsSent should return the correct number of cards sent to the recipient.")
    }

    func testDebugDescription() {
        // Arrange
        let recipient = Recipient(
            addressLine1: "123 Main St",
            addressLine2: "Apt 4B",
            city: "Springfield",
            state: "IL",
            zip: "62704",
            country: "USA",
            firstName: "John",
            lastName: "Doe",
            category: .home
        )
        let card1 = Card(cardDate: Date(), eventType: EventType(eventName: "Test 1"), cardFront: GreetingCard(cardName: "Card 1", cardFront: nil, cardManufacturer: "Card 1 Manufacturer", cardURL: "Card 1 URL"), recipient: Recipient(addressLine1: "Address Line 1", addressLine2: "Address Line 2", city: "Address City", state: "AA", zip: "12345", country: "US", firstName: "First Name", lastName: "Last Name", category: Category.home))
        let card2 = Card(cardDate: Date(), eventType: EventType(eventName: "Test 2"), cardFront: GreetingCard(cardName: "Card 2", cardFront: nil, cardManufacturer: "Card 2 Manufacturer", cardURL: "Card 2 URL"), recipient: Recipient(addressLine1: "Address Line 1", addressLine2: "Address Line 2", city: "Address City", state: "AA", zip: "12345", country: "US", firstName: "First Name", lastName: "Last Name", category: Category.home))
        recipient.cards = [card1, card2]

        // Act
        let debugDescription = recipient.debugDescription

        // Assert
        XCTAssert(debugDescription.contains("John Doe"), "Debug description should include the recipient's full name.")
        XCTAssert(debugDescription.contains("123 Main St"), "Debug description should include the address line 1.")
        XCTAssert(debugDescription.contains("Apt 4B"), "Debug description should include the address line 2.")
        XCTAssert(debugDescription.contains("Springfield"), "Debug description should include the city.")
        XCTAssert(debugDescription.contains("IL"), "Debug description should include the state.")
        XCTAssert(debugDescription.contains("62704"), "Debug description should include the zip code.")
        XCTAssert(debugDescription.contains("USA"), "Debug description should include the country.")
        XCTAssert(debugDescription.contains("Number of Cards - 2"), "Debug description should include the correct number of cards sent.")
    }
}
