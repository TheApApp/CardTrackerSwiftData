//
//  ViewGreetingCardsView.swift
//  GreetingTracker
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
        let eventTypeID = eventType.persistentModelID
        _greetingCards = Query(
            filter: #Predicate { $0.eventType?.persistentModelID == eventTypeID },
            sort: [SortDescriptor(\GreetingCard.cardName, order: .forward)]
        )
        
        if UIDevice.current.userInterfaceIdiom == .phone {
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
            if greetingCards.isEmpty {
                ContentUnavailableView {
                    Label("No Cards", systemImage: "doc.richtext")
                        .foregroundColor(.accentColor)
                } description: {
                    Text("There are no cards in this gallery.")
                        .foregroundColor(.accentColor)
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: gridLayout, alignment: .center, spacing: 5) {
                        ForEach(greetingCards, id: \.id ) { greetingCard in
                            GreetingCardScreenView(greetingCard: greetingCard, navigationPath: $navigationPath)
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("\(eventType.eventName) - \(greetingCards.count) Cards")
                            .foregroundColor(Color.accentColor)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if isLoading {
                            ProgressView()
                        } else {
                            Button(action: generatePDF) {
                                Image(systemName: "square.and.arrow.up")
                            }
                        }
                    }
                }
                .sheet(isPresented: $showShareSheet) {
                    if let PDFUrl = PDFUrl {
                        ShareSheet(activityItems: [PDFUrl])
                            .interactiveDismissDisabled(true)
                    }
                }
            }
        }
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


#Preview {
    ViewGreetingCardsView(eventType: EventType(eventName: "Birthday"), navigationPath: .constant(NavigationPath()))
}
