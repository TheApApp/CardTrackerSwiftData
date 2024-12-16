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

    @Query(sort: \EventType.eventName) private var events: [EventType]
    @Query(sort: \GreetingCard.cardName) private var greetingCards: [GreetingCard]
    
    @State private var selectedEvent: EventType?
    @State private var cardDate = Date()
    @State private var selectedGreetingCard: GreetingCard?
    @State var frontImageSelected: Image? = Image("frontImage")
    @State var shouldPresentCamera = false
    @State var frontPhoto = false
    @State var captureFrontImage = false
    
    init(recipient: Recipient) {
        self.recipient = recipient
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
                        Picker("Select Event Type", selection: $selectedEvent) {
                            Text("Unknown Event")
                                .tag(Optional<EventType>.none) //basically added empty tag and it solve the case
                            
                            if events.isEmpty == false {
                                Divider()
                                
                                ForEach(events) { eventType in
                                    Text(eventType.eventName)
                                        .tag(Optional(eventType))
                                }
                            }
                        }
                        
                        NavigationLink("Add Event Type", destination: NewEventView())
                        
                        DatePicker(
                            "Event Date",
                            selection: $cardDate,
                            displayedComponents: [.date])
                    }
                    
                    Section("Image") {
                        if selectedEvent != nil {
                            NavigationLink("Add Card", destination: EditGreetingCardView(greetingCard: nil))
                            
                            NavigationLink("Select card:", destination: GreetingCardsPickerView(eventType: selectedEvent!, selectedGreetingCard: $selectedGreetingCard))
                        }
                        
                        if let imageData = selectedGreetingCard?.cardFront {
                            Image(uiImage: UIImage(data: imageData)!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200, alignment: .center)
                        } else {
                            Image(uiImage: UIImage(named: "frontImage")!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200, alignment: .center)
                        }
                    }
                }
            }
            .onChange(of: selectedGreetingCard) {
                print("Selected a Greeting Card - \(String(describing: selectedGreetingCard)))")
            }
            .padding([.leading, .trailing], 10)
            .navigationBarTitle("\(recipient.fullName)")
            .navigationBarItems(trailing:
                                    HStack {
                Button(action: {
                    // TODO: add an error check to confirm they have an event and card selected
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
        print("Selected greetingCard = \(String(describing: selectedGreetingCard?.cardName))")
        /// You must have both an event and a card selected.
        if selectedEvent != nil  && selectedGreetingCard != nil {
            let card = Card(cardDate: cardDate, eventType: selectedEvent!, cardFront: selectedGreetingCard!, recipient: recipient)
            modelContext.insert(card)
        }
        do {
            try modelContext.save()
        } catch let error as NSError {
            logger.log("Save error \(error), \(error.userInfo)")
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return NewCardView(recipient: previewer.recipient)
        
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

