//
//  GreetingCardsPicker.swift
//  GreetingTracker
//
//  Created by Michael Rowe on 12/19/23.
//

import os
import SwiftData
import SwiftUI

struct GreetingCardsPickerView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    @Query(sort: \GreetingCard.cardName) private var greetingCards: [GreetingCard]
    
    @Binding var selectedGreetingCard: GreetingCard?
    
    @State private var searchText = ""
    
    private var gridLayout = [
        GridItem(.adaptive(minimum: 180), spacing: 5, alignment: .center)
    ]
    
    var eventType: EventType
    
    init(eventType: EventType, selectedGreetingCard: Binding<GreetingCard?>) {
        self.eventType = eventType
        _selectedGreetingCard = selectedGreetingCard
        let eventTypeID = eventType.persistentModelID // Note this is required to help in Macro Expansion
        _greetingCards = Query(
            filter: #Predicate {$0.eventType?.persistentModelID == eventTypeID },
            sort: [
                SortDescriptor(\GreetingCard.cardName),
            ]
        )
    }
    
    var filteredGreetingCards: [GreetingCard] {
        if searchText.isEmpty {
            return greetingCards
        } else {
            return greetingCards.filter { card in
                card.cardName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
            ScrollView {
                LazyVGrid(columns: gridLayout, alignment: .center, spacing: 5) {
                    ForEach(filteredGreetingCards, id: \.id) { greetingCard in
                        VStack {
                            Image(uiImage: UIImage(data: (greetingCard.cardFront)!) ?? UIImage(named: "frontImage")!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 175, height: 175)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .onTapGesture {
                                    selectedGreetingCard = greetingCard
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            Text(greetingCard.cardName)
                                .font(.footnote)
                        }
                    }
                }
                .padding(.horizontal)  // Reduce horizontal padding
                .padding(.top, -5)
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Filter Cards")
            .toolbar {
                ToolbarItem(placement: .principal) {
                Text("Select \(eventType.eventName) Card")
                        .foregroundColor(Color.accentColor)
                }
            }
    }
}

#Preview {
    @Previewable @State var greetingCard: GreetingCard? = GreetingCard(cardName: "Test Card", cardFront: UIImage(named: "frontImage")?.pngData(), eventType: EventType(eventName: "Birthday"), cardManufacturer: "Test Manufacturer", cardURL: "https://www.example.com")
    NavigationStack {
        GreetingCardsPickerView(eventType: EventType(eventName: "Birthday"), selectedGreetingCard: $greetingCard)
    }
}
