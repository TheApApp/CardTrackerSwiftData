//
//  ViewEventsView.swift
//  GreetingTracker
//
//  Created by Michael Rowe on 12/16/23.
//

import os
import SwiftData
import SwiftUI

struct ViewEventsView: View {
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
    
    
    // MARK: Public accessors for testing
    #if DEBUG
    var test_eventType: EventType {
        return eventType
    }
    var test_cards: [Card] {
        return cards
    }
    var test_isIphone: Bool {
        return iPhone
    }
    var test_PDFUrl: URL? {
        return PDFUrl
    }
    var test_showShareSheet: Bool {
        return showShareSheet
    }
    var test_isLoading: Bool {
        return isLoading
    }
    #endif
    
    init(eventType: EventType, navigationPath: Binding<NavigationPath>) {
        print("DEBUG ViewEventsView: eventType : \(String(describing: eventType.eventName))")
        self.eventType = eventType
        let eventTypeID = eventType.persistentModelID // Note this is required to help in Macro Expansion
        _cards = Query(
            filter: #Predicate {$0.eventType?.persistentModelID == eventTypeID },
            sort: [
                SortDescriptor(\Card.cardDate, order: .reverse),
            ]
        )
        if UIDevice.current.userInterfaceIdiom == .phone {
            iPhone = true
            self.gridLayout = [
                GridItem(.adaptive(minimum: 160), spacing: 10, alignment: .center)
            ]
        } else if UIDevice.current.userInterfaceIdiom == .vision {
            self.gridLayout = [
                GridItem(.adaptive(minimum: 320), spacing: 20, alignment: .leading)
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
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("\(eventType.eventName) - \(cards.count) Sent")
                        .foregroundColor(Color.accentColor)
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    if isLoading {
                        ProgressView()
                    } else {
                        Button(action: generatePDF) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showShareSheet, content: {
            if let PDFUrl = PDFUrl {
                ShareSheet(activityItems: [PDFUrl])
                    .interactiveDismissDisabled(true)
            }
        })
    }
    
    internal func generatePDF() {
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
