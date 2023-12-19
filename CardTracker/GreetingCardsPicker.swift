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
    
    private var gridLayout = [
        GridItem(.adaptive(minimum: 160), spacing: 10, alignment: .center)
    ]
    
    var eventType: EventType
    
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
    }
    
    var body: some View {
        Form {
            LazyVGrid(columns: gridLayout, alignment: .center, spacing: 5) {
                ForEach(greetingCards) { greetingCard in
                    CardView(cardImage: UIImage(data: greetingCard.cardFront!)!, event: greetingCard.eventType?.eventName ?? "Unknown")
                }
            }
        }
    }
}
