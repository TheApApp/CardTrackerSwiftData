//
//  ConstantsTests.swift
//  Greeting Tracker
//
//  Created by Michael Rowe1 on 1/12/25.
//


import XCTest
@testable import CardTracker

final class ConstantsTests: XCTestCase {

    // MARK: - Test cardDateFormatter

    func testCardDateFormatter() {
        // Arrange
        let testDate = Date(timeIntervalSince1970: 0) // January 1, 1970
        let expectedFormattedDate = "12/31/69" // Format may vary depending on locale

        // Act
        let formattedDate = cardDateFormatter.string(from: testDate)

        // Assert
        XCTAssertEqual(formattedDate, expectedFormattedDate, "The cardDateFormatter should correctly format dates.")
    }

    // MARK: - Test NavBarItemChosen Enum

    func testNavBarItemChosenHashable() {
        // Arrange
        let item = NavBarItemChosen.newCard

        // Act
        let id = item.id

        // Assert
        XCTAssertEqual(id, item.hashValue, "The NavBarItemChosen's id should be equal to its hashValue.")
    }

    // MARK: - Test ListView Enum

    func testListViewEnumCases() {
        // Arrange
        let allCases = ListView.allCases

        // Assert
        XCTAssertEqual(allCases.count, 3, "ListView should have 3 cases.")
        XCTAssertTrue(allCases.contains(.events), "ListView should contain 'events'.")
        XCTAssertTrue(allCases.contains(.recipients), "ListView should contain 'recipients'.")
        XCTAssertTrue(allCases.contains(.greetingCard), "ListView should contain 'greetingCard'.")
    }

    func testListViewIds() {
        // Arrange
        let eventView = ListView.events
        let recipientView = ListView.recipients
        let greetingCardView = ListView.greetingCard

        // Act & Assert
        XCTAssertEqual(eventView.id, "events", "ListView 'events' id should be 'events'.")
        XCTAssertEqual(recipientView.id, "recipients", "ListView 'recipients' id should be 'recipients'.")
        XCTAssertEqual(greetingCardView.id, "greetingCard", "ListView 'greetingCard' id should be 'greetingCard'.")
    }

    // MARK: - Test maxBytes Constant

    func testMaxBytesConstant() {
        // Arrange
        let expectedMaxBytes = 1_000_000

        // Act & Assert
        XCTAssertEqual(maxBytes, expectedMaxBytes, "maxBytes should be equal to 1,000,000 bytes.")
    }
}
