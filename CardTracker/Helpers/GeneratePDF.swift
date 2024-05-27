//
//  GeneratePDF.swift
//  Greet Keeper
//
//  Created by Michael Rowe on 5/27/24.
//

import PDFKit
import SwiftUI

class GeneratePDF {
    var title: String
    var cards: [Card]?
    var greetingCards: [GreetingCard]?
    var cardArray: Bool

    private var cardsArray: [Card] = []
    private var greetingArray: [GreetingCard] = []
    
    init(title: String, cards: [Card]?, greetingCards: [GreetingCard]?, cardArray: Bool) {
        self.title = title
        self.cards = cards
        self.greetingCards = greetingCards
        self.cardArray = cardArray
    }

    @MainActor
    func render(viewsPerPage: Int) async -> URL {
        if cardArray {
            cardsArray = cards.map { $0 }!
        } else {
            greetingArray = greetingCards.map { $0 }!
        }
            
        let url = URL.documentsDirectory.appending(path: "\(title)-cards.pdf")
        var pageSize = CGRect(x: 0, y: 0, width: 612, height: 792)
        
        guard let pdfOutput = CGContext(url as CFURL, mediaBox: &pageSize, nil) else {
            return url
        }
        
        let numberOfPages = Int((cardArray ? cardsArray.count : greetingArray.count + viewsPerPage - 1) / viewsPerPage)
        let viewsPerRow = 4
        let rowsPerPage = 4
        let spacing = 10.0
        
        for pageIndex in 0..<numberOfPages {
            let startIndex = pageIndex * viewsPerPage
            let endIndex = min(startIndex + viewsPerPage, cardArray ? cardsArray.count : greetingArray.count)
            
            var currentX: Double = 0
            var currentY: Double = 0
            
            pdfOutput.beginPDFPage(nil)
            
            let renderTop = ImageRenderer(content: EventTypeView(title: title, isCards: false))
            renderTop.render { size, renderTop in
                pdfOutput.move(to: CGPoint(x: 0.0, y: 0.0))
                pdfOutput.translateBy(x: 0.0, y: 692)
                currentY += 692
                renderTop(pdfOutput)
            }
            pdfOutput.translateBy(x: spacing / 2, y: -160)
            
            for row in 0..<rowsPerPage {
                for col in 0..<viewsPerRow {
                    let index = startIndex + row * viewsPerRow + col
                    if cardArray {
                        if index < endIndex, let event = cardsArray[safe: index] {
                            let renderBody = ImageRenderer(content: PrintView(card: event, greetingCard: nil, isEventType: .events))
                            renderBody.render { size, renderBody in
                                renderBody(pdfOutput)
                                pdfOutput.translateBy(x: size.width + 10, y: 0)
                                currentX += size.width + 10
                            }
                        }
                    } else {
                        if index < endIndex, let greeting = greetingArray[safe: index] {
                            let renderBody = ImageRenderer(content: PrintView(card: nil, greetingCard: greeting, isEventType: .greetingCard))
                            renderBody.render { size, renderBody in
                                renderBody(pdfOutput)
                                pdfOutput.translateBy(x: size.width + 10, y: 0)
                                currentX += size.width + 10
                            }
                        }
                    }
                }
                pdfOutput.translateBy(x: -pageSize.width + 5, y: -144)
                currentY -= 153
                currentX = 0
            }
            
            let renderBottom = ImageRenderer(content: FooterView(page: pageIndex + 1, pages: numberOfPages))
            pdfOutput.move(to: CGPoint(x: 0, y: 0))
            pdfOutput.translateBy(x: 0, y: 40)
            renderBottom.render { size, renderBottom in
                renderBottom(pdfOutput)
            }
            pdfOutput.endPDFPage()
        }
        pdfOutput.closePDF()
        return url
    }
}
