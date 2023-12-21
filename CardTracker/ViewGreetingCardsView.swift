//
//  ViewGreetingCardsView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/18/23.
//

import os
import SwiftData
import SwiftUI

/// ViewGreetingCardsView allows for capturing new Greeting Cards into the Image gallery.  Images can be captured in one of two ways, importing from the user's Photo library or via the camera on their device.  The image gallery will be sorted by EventType
struct ViewGreetingCardsView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentationMode) var presentationMode
    @Query(sort: \GreetingCard.cardName, order: .forward) private var greetingCards: [GreetingCard]
    
    private let blankCardFront = UIImage(named: "frontImage")
    private var gridLayout: [GridItem]
    private var iPhone = false
    private var eventType: EventType
    
    // MARK: PDF Properties
    @State var PDFUrl: URL?
    @State var showShareSheet: Bool = false
    
    init(eventType: EventType) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.systemGreen,
            .font: UIFont(name: "ArialRoundedMTBold", size: 35)!]
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.systemGreen,
            .font: UIFont(name: "ArialRoundedMTBold", size: 20)!]
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        
        self.eventType = eventType
        let eventTypeID = eventType.persistentModelID // Note this is required to help in Macro Expansion
        _greetingCards = Query(
            filter: #Predicate {$0.eventType?.persistentModelID == eventTypeID },
            sort: [
                SortDescriptor(\GreetingCard.cardName, order: .reverse),
            ]
        )
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.gridLayout = [
                GridItem(.adaptive(minimum: 320), spacing: 20, alignment: .center)
            ]
        } else {
            iPhone = true
            self.gridLayout = [
                GridItem(.adaptive(minimum: 160), spacing: 10, alignment: .center)
            ]
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                EventTypeView(eventType: eventType)
                    .scaledToFill()
                    .frame(width: 320, height: 75)
                    .padding(.leading, 15)
                Spacer()
            }
            ScrollView {
                LazyVGrid(columns: gridLayout, alignment: .center, spacing: 5) {
                    ForEach(greetingCards) { greetingCard in
//                        CardView(cardImage: UIImage(data: greetingCard.cardFront!)!)
                        ScreenView(card: nil, greetingCard: greetingCard, isEventType: .greetingCard)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing:
                                        HStack {
                    ShareLink("Export PDF", item: render(viewsPerPage: 16))
                }
                )
            }
        }
    }
    
    @MainActor func render(viewsPerPage: Int) -> URL {
        let greetingCardsArray: [GreetingCard] = greetingCards.map { $0 }
        let url = URL.documentsDirectory.appending(path: "\(eventType.eventName)-cards.pdf")
        var pageSize = CGRect(x: 0, y: 0, width: 612, height: 792)
        
        guard let pdfOutput = CGContext(url as CFURL, mediaBox: &pageSize, nil) else {
            return url
        }
        
        let numberOfPages = Int((greetingCards.count + viewsPerPage - 1) / viewsPerPage)   // Round to number of pages
        let viewsPerRow = 4
        let rowsPerPage = 4
        let spacing = 10.0
        
        for pageIndex in 0..<numberOfPages {
            let startIndex = pageIndex * viewsPerPage
            let endIndex = min(startIndex + viewsPerPage, greetingCardsArray.count)
            
            var currentX : Double = 0
            var currentY : Double = 0
            
            pdfOutput.beginPDFPage(nil)
            
            // Printer header - top 160 points of the page
            let renderTop = ImageRenderer(content: EventTypeView(eventType: eventType))
            renderTop.render { size, renderTop in
                // Go to Bottom Left of Page and then translate up to 160 points from the top
                pdfOutput.move(to: CGPoint(x: 0.0, y: 0.0))
                pdfOutput.translateBy(x: 0.0, y: 692)
                currentY += 692
                renderTop(pdfOutput)
            }
            pdfOutput.translateBy(x: spacing / 2, y: -160)
            
            for row in 0..<rowsPerPage {
                for col in 0..<viewsPerRow {
                    let index = startIndex + row * viewsPerRow + col
                    if index < endIndex, let greetingCard = greetingCardsArray[safe: index] {
                        let renderBody = ImageRenderer(content: PrintView(card: nil, greetingCard: greetingCard, isEventType: .greetingCard))
                        renderBody.render { size, renderBody in
                            renderBody(pdfOutput)
                            pdfOutput.translateBy(x: size.width + 10, y: 0)
                            currentX += size.width + 10
                        }
                    }
                }
                pdfOutput.translateBy(x: -pageSize.width + 5, y: -144)
                currentY -= 153
                currentX = 0
            }
            
            // Print Footer - from bottom of page, up 40 points
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
