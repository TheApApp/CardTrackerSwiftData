//
//  GreetingCardsPicker.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/19/23.
//

import os
import SwiftData
import SwiftUI

struct GreetingCardsPicker: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    @Query(sort: \GreetingCard.cardName) private var greetingCards: [GreetingCard]
    
    @Binding var selectedGreetingCard: GreetingCard?
    @State private var isSelected = false
    
    private var gridLayout = [
        GridItem(.adaptive(minimum: 140), spacing: 10, alignment: .center)
    ]
    
    var eventType: EventType
    
    init(eventType: EventType, selectedGreetingCard: Binding<GreetingCard?>) {
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
        _selectedGreetingCard = selectedGreetingCard
        let eventTypeID = eventType.persistentModelID // Note this is required to help in Macro Expansion
        _greetingCards = Query(
            filter: #Predicate {$0.eventType?.persistentModelID == eventTypeID },
            sort: [
                SortDescriptor(\GreetingCard.cardName, order: .reverse),
            ]
        )
    }
    
    var body: some View {
        VStack {
            LazyVGrid(columns: gridLayout, alignment: .center, spacing: 5) {
                ForEach(greetingCards, id: \.id) { greetingCard in
                    CardView(cardImage: greetingCard.cardUIImage())
                        .aspectRatio(2/3, contentMode: .fit)
                        .shadow(color: .green, radius: isSelected ? 2 : 0 )
                        .onTapGesture {
                            // Why does a view care about modifying your card's state?
                            // Tell the card what state is it, and allow the
                            // view to redraw it if necessary.
                            self.isSelected.toggle()
                            self.selectedGreetingCard = greetingCard
                            self.presentationMode.wrappedValue.dismiss()
                        }
                }
            }
        }
    }
}
