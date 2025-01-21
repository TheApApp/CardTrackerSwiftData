//
//  GeneratePDFTests.swift
//  Greeting Tracker
//
//  Created by Michael Rowe1 on 1/12/25.
//


import XCTest
@testable import GreetingTracker

final class GeneratePDFTests: XCTestCase {
    
    func testInitialization() {
        let title = "Test PDF"
        let cards: [Card] = [Card(cardDate: Date(), eventType: EventType(eventName: "Test 1"), cardFront: GreetingCard(cardName: "Card 1", cardFront: nil, cardManufacturer: "Card 1 Manufacturer", cardURL: "Card 1 URL"), recipient: Recipient(addressLine1: "Address Line 1", addressLine2: "Address Line 2", city: "Address City", state: "AA", zip: "12345", country: "US", firstName: "First Name", lastName: "Last Name", category: Category.home)), Card(cardDate: Date(), eventType: EventType(eventName: "Test 2"), cardFront: GreetingCard(cardName: "Card 2", cardFront: nil, cardManufacturer: "Card 2 Manufacturer", cardURL: "Card 2 URL"), recipient: Recipient(addressLine1: "Address Line 1", addressLine2: "Address Line 2", city: "Address City", state: "AA", zip: "12345", country: "US", firstName: "First Name", lastName: "Last Name", category: Category.home))]
        let greetingCards: [GreetingCard] = []
        let pdfGenerator = GeneratePDF(title: title, cards: cards, greetingCards: greetingCards, cardArray: true)
        
        XCTAssertEqual(pdfGenerator.title, title)
        XCTAssertEqual(pdfGenerator.cards?.count, cards.count)
        XCTAssertEqual(pdfGenerator.greetingCards?.count, greetingCards.count)
        XCTAssertTrue(pdfGenerator.cardArray)
    }
    
    func testLayoutGrid() {
        let pdfGenerator = GeneratePDF(title: "Test", cards: nil, greetingCards: nil, cardArray: true)
        let layoutGrid = pdfGenerator.layoutGridForTesting
        
        XCTAssertEqual(layoutGrid.count, 16, "The layout grid should have 16 positions.")
        
        let firstPosition = layoutGrid[0]
        XCTAssertEqual(firstPosition[0], 36, "The x-coordinate of the first grid position should match the left margin.")
        XCTAssertEqual(firstPosition[1], 230, "The y-coordinate of the first grid position should match the top margin.")
    }
    
    func testRenderCreatesPDFFile() async throws {
        let title = "Test PDF"
        let cards: [Card] = [Card(cardDate: Date(), eventType: EventType(eventName: "Test 1"), cardFront: GreetingCard(cardName: "Card 1", cardFront: nil, cardManufacturer: "Card 1 Manufacturer", cardURL: "Card 1 URL"), recipient: Recipient(addressLine1: "Address Line 1", addressLine2: "Address Line 2", city: "Address City", state: "AA", zip: "12345", country: "US", firstName: "First Name", lastName: "Last Name", category: Category.home)), Card(cardDate: Date(), eventType: EventType(eventName: "Test 2"), cardFront: GreetingCard(cardName: "Card 2", cardFront: nil, cardManufacturer: "Card 2 Manufacturer", cardURL: "Card 2 URL"), recipient: Recipient(addressLine1: "Address Line 1", addressLine2: "Address Line 2", city: "Address City", state: "AA", zip: "12345", country: "US", firstName: "First Name", lastName: "Last Name", category: Category.home))]
        let greetingCards: [GreetingCard] = []
        let pdfGenerator = GeneratePDF(title: title, cards: cards, greetingCards: greetingCards, cardArray: true)
        
        let fileURL = await pdfGenerator.render(viewsPerPage: 4)
        
        XCTAssertTrue(FileManager.default.fileExists(atPath: fileURL.path), "The PDF file should be created at the expected location.")
        
        // Clean up
        try? FileManager.default.removeItem(at: fileURL)
    }
    
    @MainActor func testRenderHeader() async {
        let pdfGenerator = GeneratePDF(title: "Test Header", cards: nil, greetingCards: nil, cardArray: true)
        guard let (context, data) = createPDFContext() else {
            XCTFail("Failed to create a PDF context.")
            return
        }

        pdfGenerator.renderHeader(context)

        // End the PDF page and close the context
        context.endPDFPage()
        context.closePDF()

        // Validate that the PDF data is non-empty
        XCTAssertFalse(data.length == 0, "The PDF data should not be empty after rendering the header.")
    }

    @MainActor func testRenderContent() async {
        let pdfGenerator = GeneratePDF(title: "Test Content", cards: nil, greetingCards: nil, cardArray: true)
        guard let (context, data) = createPDFContext() else {
            XCTFail("Failed to create a PDF context.")
            return
        }

        let card = Card(cardDate: Date(), eventType: EventType(eventName: "Test 1"), cardFront: GreetingCard(cardName: "Card 1", cardFront: nil, cardManufacturer: "Card 1 Manufacturer", cardURL: "Card 1 URL"), recipient: Recipient(addressLine1: "Address Line 1", addressLine2: "Address Line 2", city: "Address City", state: "AA", zip: "12345", country: "US", firstName: "First Name", lastName: "Last Name", category: Category.home))
        pdfGenerator.renderContent(context, card, at: [100, 200])

        // End the PDF page and close the context
        context.endPDFPage()
        context.closePDF()

        // Validate that the PDF data is non-empty
        XCTAssertFalse(data.length == 0, "The PDF data should not be empty after rendering content.")
    }
    
    @MainActor func testRenderFooter() async {
        let pdfGenerator = GeneratePDF(title: "Test Footer", cards: nil, greetingCards: nil, cardArray: true)
        guard let (context, data) = createPDFContext() else {
            XCTFail("Failed to create a PDF context.")
            return
        }

        pdfGenerator.renderFooter(context, pageIndex: 1, totalPages: 3)

        // End the PDF page and close the context
        context.endPDFPage()
        context.closePDF()

        // Validate that the PDF data is non-empty
        XCTAssertFalse(data.length == 0, "The PDF data should not be empty after rendering the footer.")
    }
    
    // MARK: - Helper Methods
    
    private func createPDFContext() -> (context: CGContext, data: NSMutableData)? {
        let data = NSMutableData()
        guard let consumer = CGDataConsumer(data: data as CFMutableData) else { return nil }

        var mediaBox = CGRect(x: 0, y: 0, width: 612, height: 792)
        guard let context = CGContext(consumer: consumer, mediaBox: &mediaBox, nil) else { return nil }

        return (context, data)
    }
}
