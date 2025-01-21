//
//  GreetingCardsPicker.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/19/23.
//

//
//  GreetingCardsPicker.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/19/23.
//

import os
import SwiftData
import SwiftUI

struct GreetingCardsPickerView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentationMode) var presentationMode

    // Added State for Search Text
    @State private var searchText = ""

    @Query(sort: \GreetingCard.cardName) private var greetingCards: [GreetingCard]
    
    @Binding var selectedGreetingCard: GreetingCard?
<<<<<<< Updated upstream
    
    @State private var searchText = ""
    
=======

>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
    
=======

    // Computed property to filter the cards based on searchText
>>>>>>> Stashed changes
    var filteredGreetingCards: [GreetingCard] {
        if searchText.isEmpty {
            return greetingCards
        } else {
<<<<<<< Updated upstream
            return greetingCards.filter { card in
                card.cardName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
            ScrollView {
                LazyVGrid(columns: gridLayout, alignment: .center, spacing: 5) {
                    ForEach(filteredGreetingCards, id: \.id) { greetingCard in
=======
            return greetingCards.filter { $0.cardName.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationView { // Added NavigationView to handle search bar
            ScrollView {
                LazyVGrid(columns: gridLayout, alignment: .center, spacing: 5) {
                    ForEach(filteredGreetingCards, id: \.id) { greetingCard in // Using filtered array
>>>>>>> Stashed changes
                        VStack {
                            Image(uiImage: UIImage(data: (greetingCard.cardFront)!) ?? UIImage(named: "frontImage")!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
<<<<<<< Updated upstream
                                .frame(width: 175, height: 175)
=======
                                .frame(width: 195, height: 195)
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
                .padding(.horizontal)  // Reduce horizontal padding
                .padding(.top, -5)
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Filter Cards")
            .toolbar {
                ToolbarItem(placement: .principal) {
                Text("Select \(eventType.eventName) Card")
                        .foregroundColor(Color.accentColor)
                }
=======
                .padding()
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search Cards") // search bar added
            .navigationTitle("Select \(eventType.eventName) Card")
            .navigationBarTitleDisplayMode(.inline)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Select \(eventType.eventName) Card")
                    .foregroundColor(Color.accentColor)
>>>>>>> Stashed changes
            }
    }
}

#Preview {
    @Previewable @State var greetingCard: GreetingCard? = GreetingCard(cardName: "Test Card", cardFront: UIImage(named: "frontImage")?.pngData(), eventType: EventType(eventName: "Birthday"), cardManufacturer: "Test Manufacturer", cardURL: "https://www.example.com")
    NavigationStack {
        GreetingCardsPickerView(eventType: EventType(eventName: "Birthday"), selectedGreetingCard: $greetingCard)
    }
}
