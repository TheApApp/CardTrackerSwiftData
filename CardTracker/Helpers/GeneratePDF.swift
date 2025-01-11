//
//  GeneratePDF.swift
//  Greet Keeper
//
//  Created by Michael Rowe on 5/27/24.
//

import os
import PDFKit
import SwiftUI

class GeneratePDF {
    var title: String
    var cards: [Card]?
    var greetingCards: [GreetingCard]?
    var cardArray: Bool
    let logger = Logger(subsystem: "PDF Render", category: "Print")
    
    // 8.5 * 11 at 72 dpi should be
    // 612 * 792
    // If we remove a half inch on all sides we end up with (36dpi)
    // 540 * 720
    
    // Width  540 we can now divide by 4 which is 135
    //        and if we add a 2.5 dpi border we have 130 dots for width
    // Height 720 we divide by 5 (for header and footer) end up with 144
    //        and if we add a 2.5 dpi border we have 139 dots for height
    //
    // So we have a header that is Width 540, Height 139
    // a 5 dpi space
    // 16 images of 130*139 with 5 dpi between
    // a 5 dpi space
    // Footer of width 540, height 139
    
    let pageHeight = 792
    let pageWidth = 612
    let origin = (x: 0, y: 0)
    
    let layoutGrid = [
        [0.0, -149.0], [140.0, 0.0], [140.0, 0.0] , [140.0, 0.0],
        [-422.0, -149.0], [140.0, 0.0], [140.0, 0.0] , [140.0, 0.0],
        [-422.0, -149.0], [140.0, 0.0], [140.0, 0.0] , [140.0, 0.0],
        [-422.0, -149.0], [140.0, 0.0], [140.0, 0.0] , [140.0, 0.0]
    ]

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
        var pageSize = CGRect(x: origin.x, y: origin.y, width: pageWidth, height: pageHeight)
        
        guard let pdfOutput = CGContext(url as CFURL, mediaBox: &pageSize, nil) else {
            return url
        }
        
        let numberOfPages = Int((cardArray ? (cardsArray.count + viewsPerPage - 1) : (greetingArray.count + viewsPerPage - 1)) / viewsPerPage)
        let viewsPerRow = 4
        let rowsPerPage = 4
        var pageIndex = 0
        
        // using repeat while loop since we will always print at least 1 page
        repeat {
            let startIndex = pageIndex * viewsPerPage
            let endIndex = min(startIndex + viewsPerPage, cardArray ? cardsArray.count : greetingArray.count)

            var image = 0
            
            pdfOutput.beginPDFPage(nil)
            
            let renderTop = ImageRenderer(content: DisplayEventTypeView(title: title, isCards: false))
            renderTop.render { size, renderTop in
                pdfOutput.move(to: CGPoint(x: origin.x, y: origin.y))
                pdfOutput.translateBy(x: 10.0, y: 720)
                renderTop(pdfOutput)
            }
            
            for row in 0..<rowsPerPage {
                logger.debug("\n\rPrinting Images")
                for col in 0..<viewsPerRow {
                    let index = startIndex + row * viewsPerRow + col
                    logger.debug("Image = \(image)")
                    if cardArray {
                        if index < endIndex, let event = cardsArray[safe: index] {
                            let renderBody = ImageRenderer(content: PrintView(card: event, greetingCard: nil, isEventType: .events))
                            
                            renderBody.render { size, renderBody in
                                pdfOutput.move(to: CGPoint(x: origin.x, y: origin.y))
                                let x = layoutGrid[image].first ?? 0
                                let y = layoutGrid[image].last ?? 0
                                pdfOutput.translateBy(x: x, y: y)
                                logger.debug("pdfOutput.translateBy info x = \(pdfOutput.boundingBoxOfPath.origin.x) and y = \(pdfOutput.boundingBoxOfPath.origin.y) \n\r LayoutGrid x=\(x) y=\(y)\n\r")
                                renderBody(pdfOutput)
                            }
                        }
                    } else {
                        if index < endIndex, let greeting = greetingArray[safe: index] {
                            let renderBody = ImageRenderer(content: PrintView(card: nil, greetingCard: greeting, isEventType: .greetingCard))
                            renderBody.render { size, renderBody in
                                pdfOutput.move(to: CGPoint(x: origin.x, y: origin.y))
                                let x = layoutGrid[image].first ?? 0
                                let y = layoutGrid[image].last ?? 0
                                pdfOutput.translateBy(x: x, y: y)
                                logger.debug("pdfOutput.translateBy info x = \(pdfOutput.boundingBoxOfPath.origin.x) and y = \(pdfOutput.boundingBoxOfPath.origin.y) \n\r LayoutGrid x=\(x) y=\(y)\n\r")
                                renderBody(pdfOutput)
                            }
                        }
                    }
                    image += 1
                }
            }
            
            pageIndex += 1
            let renderBottom = ImageRenderer(content: FooterView(page: pageIndex, pages: numberOfPages))
            pdfOutput.translateBy(x: -420.0, y: -80.0)
            renderBottom.render { size, renderBottom in
                renderBottom(pdfOutput)
            }
            pdfOutput.endPDFPage()
            image = 0
        } while pageIndex < numberOfPages
        
        pdfOutput.closePDF()
        return url
    }
}
