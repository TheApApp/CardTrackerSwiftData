//
//  AddNewCardView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/11/23.
//

import os
import SwiftData
import SwiftUI

struct NewCardView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    var recipient: Recipient
//    @State var passedEvent: EventType
    @Query(sort: \EventType.eventName) private var events: [EventType]
    @Query(sort: \GreetingCard.cardName) private var greetingCards: [GreetingCard]
    
    @State private var selectedEvent: EventType?
    @State private var cardDate = Date()
    @State private var selectedGreetgingCard: GreetingCard?
    @State var frontImageSelected: Image? = Image("frontImage")
    @State var shouldPresentCamera = false
    @State var frontPhoto = false
    @State var captureFrontImage = false
    
    init(recipient: Recipient) {
        self.recipient = recipient
//        self._selectedEvent = State(initialValue: events.first)
        self._selectedEvent = State(initialValue: EventType(eventName: "Unknown"))
        let selectedEventTypeID = selectedEvent?.persistentModelID
        _greetingCards = Query(
            filter: #Predicate {$0.eventType?.persistentModelID == selectedEventTypeID },
            sort: [
                SortDescriptor(\GreetingCard.cardName, order: .reverse),
            ]
        )
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section("Card Information") {
                        Picker("Select type", selection: $selectedEvent) {
                            Text("").tag("") //basically added empty tag and it solve the case
                            ForEach(events) { event in
                                Text(event.eventName)
                                    .tag(Optional(event))
                            }
                        }
                        
                        DatePicker(
                            "Event Date",
                            selection: $cardDate,
                            displayedComponents: [.date])
                    }
                }
                .padding(.bottom, 5)
                if selectedEvent != nil {
                    GreetingCardsPicker(eventType: selectedEvent ?? EventType(eventName: "Unknown"), selectedGreetingCard: $selectedGreetgingCard)
                }
            }
            .padding([.leading, .trailing], 10)
            .navigationBarTitle("\(recipient.fullName)")
            .navigationBarItems(trailing:
                                    HStack {
                Button(action: {
                    saveCard()
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "square.and.arrow.down")
                        .font(.largeTitle)
                        .foregroundColor(.accentColor)
                })
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.down.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.accentColor)
                })
            }
            )
        }
        .foregroundColor(.accentColor)
    }
    
    func saveCard() {
        let logger=Logger(subsystem: "com.theapapp.cardTracker", category: "NewCardView")
        logger.log("saving...")
        print("Selected Event = \(String(describing: selectedEvent?.eventName))")
        if selectedEvent != nil {
            let card = Card(cardDate: cardDate, eventType: selectedEvent!, cardFront: selectedGreetgingCard ?? GreetingCard(cardName: "", cardFront: frontImageSelected?.asUIImage().pngData(), eventType: selectedEvent, cardURL: URL(string: "")), recipient: recipient)
            print("Selected Event = \(String(describing: selectedEvent))")
            modelContext.insert(card)
        }
        do {
            try modelContext.save()
        } catch let error as NSError {
            logger.log("Save error \(error), \(error.userInfo)")
        }
    }
}

