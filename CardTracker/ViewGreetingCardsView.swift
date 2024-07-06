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
    
    @Binding var navigationPath: NavigationPath
    
    // MARK: PDF Properties
    @State private var PDFUrl: URL?
    @State private var showShareSheet: Bool = false
    @State private var isLoading: Bool = false
    
    init(eventType: EventType, navigationPath: Binding<NavigationPath>) {
        self.eventType = eventType
        let eventTypeID = eventType.persistentModelID // Note this is required to help in Macro Expansion
        _greetingCards = Query(
            filter: #Predicate {$0.eventType?.persistentModelID == eventTypeID },
            sort: [
                SortDescriptor(\GreetingCard.cardName, order: .forward),
            ]
        )
        if UIDevice.current.userInterfaceIdiom == .phone || UIDevice.current.userInterfaceIdiom == .vision {
            iPhone = true
            self.gridLayout = [
                GridItem(.adaptive(minimum: 160), spacing: 10, alignment: .center)
            ]
        } else {
            self.gridLayout = [
                GridItem(.adaptive(minimum: 320), spacing: 20, alignment: .center)
            ]
        }
        self._navigationPath = navigationPath
    }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: gridLayout, alignment: .center, spacing: 5) {
                    ForEach(greetingCards) { greetingCard in
                        ScreenView(card: nil, greetingCard: greetingCard, isEventType: .greetingCard, navigationPath: $navigationPath)
                    }
                }
                .navigationBarItems(trailing:
                    HStack {
                        if isLoading {
                            ProgressView()
                        } else {
                            Button(action: generatePDF) {
                                Image(systemName: "square.and.arrow.up")
                            }
                        }
                    }
                )
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("\(eventType)")
        }
        .sheet(isPresented: $showShareSheet, content: {
            if let PDFUrl = PDFUrl {
                ShareSheet(activityItems: [PDFUrl])
            }
        })
    }
    
    private func generatePDF() {
        isLoading = true
        Task {
            let pdfGenerator = GeneratePDF(title: "\(eventType.eventName)", cards: nil, greetingCards: greetingCards, cardArray: false)
            let pdfUrl = await pdfGenerator.render(viewsPerPage: 16)
            PDFUrl = pdfUrl
            isLoading = false
            showShareSheet = true
        }
    }
}
