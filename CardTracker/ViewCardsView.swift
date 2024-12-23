//
//  ViewCardsView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/16/23.
//

import os
import SwiftData
import SwiftUI

struct ViewCardsView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var isIphone: IsIphone
    @Query(sort: [SortDescriptor(\Card.cardDate, order: .reverse)]) private var cards: [Card]
    
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
        _cards = Query(
            filter: #Predicate {$0.eventType?.persistentModelID == eventTypeID },
            sort: [
                SortDescriptor(\Card.cardDate, order: .reverse),
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
                    ForEach(cards) { card in
                        ScreenView(card: card, greetingCard: nil, isEventType: .events, navigationPath: $navigationPath)
                    }
                    .padding()
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
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("\(eventType.eventName) - \(cards.count)")
        }
        .sheet(isPresented: $showShareSheet, content: {
            if let PDFUrl = PDFUrl {
                ShareSheet(activityItems: [PDFUrl])
                    .interactiveDismissDisabled(true)
            }
        })
    }
    
    private func generatePDF() {
        isLoading = true
        Task {
            let pdfGenerator = GeneratePDF(title: "\(eventType.eventName)", cards: cards, greetingCards: nil, cardArray: true)
            let pdfUrl = await pdfGenerator.render(viewsPerPage: 16)
            PDFUrl = pdfUrl
            isLoading = false
            showShareSheet = true
        }
    }
}
