//
//  GeneratePDF 2.swift
//  Greeting Tracker
//
//  Created by Michael Rowe1 on 1/12/25.
//


//  GeneratePDF.swift
//  Greet Keeper
//
//  Created by Michael Rowe on 5/27/24.

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

import os
import PDFKit
import SwiftUI

class GeneratePDF {
    var title: String
    var cards: [Card]?
    var greetingCards: [GreetingCard]?
    var cardArray: Bool
    private let logger = Logger(subsystem: "PDF Render", category: "Print")
    private var numberOfImages: Int?

    private let pageHeight = 792.0
    private let pageWidth = 612.0
    private let origin = CGPoint(x: 0, y: 0)

    private let layoutGrid: [[CGFloat]] = {
        let cellWidth: CGFloat = 135    // Total cell width (including margins/spacings)
        let cellHeight: CGFloat = 148  // Total cell height (including margins/spacings)
        let xMargin: CGFloat = 36      // Left margin
        let yMargin: CGFloat = 230      // Top margin

        var positions: [[CGFloat]] = []
        for row in 0..<4 {
            for col in 0..<4 {
                let x = xMargin + CGFloat(col) * cellWidth
                let y = yMargin + CGFloat(row) * cellHeight
                positions.append([x, y])
            }
        }
        return positions
    }()

    init(title: String, cards: [Card]?, greetingCards: [GreetingCard]?, cardArray: Bool) {
        self.title = title
        self.cards = cards
        self.greetingCards = greetingCards
        self.cardArray = cardArray
        self.numberOfImages = cardArray ? cards?.count : greetingCards?.count
    }

    @MainActor
    func render(viewsPerPage: Int) async -> URL {
        let url = URL.documentsDirectory.appendingPathComponent("\(title)-cards.pdf")
        var pageSize = CGRect(origin: origin, size: CGSize(width: pageWidth, height: pageHeight))

        guard let pdfOutput = CGContext(url as CFURL, mediaBox: &pageSize, nil) else {
            return url
        }

        
        let dataArray : [Any] = cardArray ? cards ?? [] : greetingCards ?? []
        let numberOfPages = Int(ceil(Double(dataArray.count) / Double(viewsPerPage)))

        var pageIndex = 0
        repeat {
            let startIndex = pageIndex * viewsPerPage
            let endIndex = min(startIndex + viewsPerPage, dataArray.count)

            pdfOutput.beginPDFPage(nil)
            renderHeader(pdfOutput)

            for row in 0..<4 {
                for col in 0..<4 {
                    let gridIndex = row * 4 + col
                    let index = startIndex + gridIndex
                    if index < endIndex {
                        let gridPosition = layoutGrid[gridIndex]
                        renderContent(pdfOutput, dataArray[index], at: gridPosition)
                    }
                }
            }

            renderFooter(pdfOutput, pageIndex: pageIndex, totalPages: numberOfPages)
            pdfOutput.endPDFPage()

            pageIndex += 1
        } while pageIndex < numberOfPages

        pdfOutput.closePDF()
        return url
    }

    @MainActor private func renderHeader(_ context: CGContext) {
        let header = ImageRenderer(content: DisplayEventTypeView(title: title, isCards: false))
        header.render { _, renderer in
            context.saveGState()
            context.translateBy(x: 10, y: 720)
            renderer(context)
            context.restoreGState()
        }
    }

    @MainActor private func renderContent(_ context: CGContext, _ data: Any, at position: [CGFloat]) {
        guard position.count == 2 else { return }
        
        var renderBody: ImageRenderer<PrintView>
        if let card = data as? Card {
            renderBody = ImageRenderer(content: PrintView(card: card, greetingCard: nil, isEventType: .events))
        } else if let greetingCard = data as? GreetingCard {
            renderBody = ImageRenderer(content: PrintView(card: nil, greetingCard: greetingCard, isEventType: .greetingCard))
        } else {
            return
        }

        renderBody.render { _, renderer in
            context.saveGState()
            let x = position[0]
            let y = pageHeight - position[1] // Invert `y` for correct placement from the top
            context.translateBy(x: x, y: y)
            renderer(context)
            context.restoreGState()
        }
    }



    @MainActor private func renderFooter(_ context: CGContext, pageIndex: Int, totalPages: Int) {
        let footer = ImageRenderer(content: FooterView(page: pageIndex + 1, pages: totalPages))
        footer.render { _, renderer in
            context.saveGState()
            context.translateBy(x: 10, y: 50)
            renderer(context)
            context.restoreGState()
        }
    }
}
