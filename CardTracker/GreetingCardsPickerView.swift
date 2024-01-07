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
    
    @Query(sort: \GreetingCard.cardName) private var greetingCards: [GreetingCard]
    
    @Binding var selectedGreetingCard: GreetingCard?
    
    private var gridLayout = [
        GridItem(.adaptive(minimum: 145), spacing: 5, alignment: .center)
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
                    Image(uiImage: greetingCard.cardUIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 130, height: 130)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .onTapGesture {
                            selectedGreetingCard = greetingCard
                            self.presentationMode.wrappedValue.dismiss()
                        }
                }
            }
            .padding()
            .navigationTitle("Select \(eventType.eventName) Card")
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        @State var greetingCard: GreetingCard? = previewer.greetingCard
        
        return GreetingCardsPickerView(eventType: previewer.eventType, selectedGreetingCard: $greetingCard)
        
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
