//
//  EditCardView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/10/23.
//

import os
import SwiftData
import SwiftUI

struct EditCardView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    @Query(sort: \EventType.eventName) private var events: [EventType]
    
    @Bindable var card: Card
    @Binding var navigationPath: NavigationPath
    var defaultImage = UIImage(named: "frontImage")
    
    @State private var cardFrontImage: Image?
    @State var frontImageSelected: Image?
    @State private var eventName: String?
    @State private var cardDate: Date = Date()
    @State private var selectedEvent: EventType?
    @State var frontPhoto = false
    @State var captureFrontImage = false
    @State var shouldPresentCamera = false
    
    init(card: Bindable<Card>, navigationPath: Binding<NavigationPath>) {
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
        
        self._card = card
        self._navigationPath = navigationPath
        
    }
    
    var body: some View {
        Form {
            Section("Event") {
                Picker(selection: $card.eventType, label: Text("Event Type")) {
                    
                    Text("Uknown Event Type")
                        .tag(Optional<EventType>.none)
                    
                    if events.isEmpty == false {
                        Divider()
                        
                        ForEach(events) { event in
                            Text(event.eventName)
                                .tag(Optional(event))
                        }
                    }
                }
            }
            
            Section("Date") {
                DatePicker(
                    "Event Date",
                    selection: $card.cardDate,
                    displayedComponents: [.date])
            }
            
            Section("Card") {
                VStack {
                    NavigationLink("Select card:", destination: GreetingCardsPickerView(eventType: card.eventType!, selectedGreetingCard: $card.cardFront ))
                    
                    if let imageData = card.cardFront {
                        Image(uiImage: UIImage(data: imageData.cardFront!)!)
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
        .navigationBarTitle( "\(card.recipient?.fullName ?? "Missing Name")", displayMode: .inline)
    }

}

struct EditAnEvent_Previews: PreviewProvider {
    static var previews: some View {
        EditCardView(card: Bindable(wrappedValue:Card(cardDate: Date(), eventType: EventType(eventName: "Dummy Event"), cardFront: GreetingCard(cardName: "Sample", cardFront: UIImage(named: "frontImage")?.pngData(), eventType: EventType(eventName: "Sample Name"), cardManufacturer: "", cardURL: "https://michaelrowe01.com"), recipient: Recipient(addressLine1: "Line 1", addressLine2: "Line 2", city: "New York", state: "NY", zip: "01234", country: "USA", firstName: "First Name", lastName: "Last Name"))), navigationPath: .constant(NavigationPath()))
    }
}
