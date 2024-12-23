//
//  EditCardView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/10/23.
//

import os
import SwiftData
import SwiftUI

/// A view for editing or updating a `Card` object, including selecting event types, dates, and card images.
struct EditCardView: View {
    /// The shared model context for performing data operations.
    @Environment(\.modelContext) var modelContext
    
    /// Provides access to the current presentation mode, allowing dismissal of the view.
    @Environment(\.presentationMode) var presentationMode
    
    /// A query for fetching and sorting `EventType` objects by their event name.
    @Query(sort: \EventType.eventName) private var events: [EventType]
    
    /// The `Card` object being edited, bound to this view.
    @Bindable var card: Card
    
    /// The navigation path used for dynamic navigation within the app.
    @Binding var navigationPath: NavigationPath
    
    /// A default placeholder image for the card's front image.
    var defaultImage = UIImage(named: "frontImage")
    
    /// The currently displayed front image of the card.
    @State private var cardFrontImage: Image?
    
    /// The front image selected by the user.
    @State var frontImageSelected: Image?
    
    /// The name of the selected event.
    @State private var eventName: String?
    
    /// The date associated with the card, initialized to the current date.
    @State private var cardDate: Date = Date()
    
    /// The event type selected for the card.
    @State private var selectedEvent: EventType?
    
    /// Indicates whether the front photo of the card is being selected.
    @State var frontPhoto = false
    
    /// Indicates whether the front image capture mode is active.
    @State var captureFrontImage = false
    
    /// Indicates whether the camera should be presented for capturing an image.
    @State var shouldPresentCamera = false
    
    /// Tracks whether the user is adding a new event.
    @State private var newEvent = false
    
    /// Initializes the `EditCardView` with a bound `Card` object and navigation path.
    /// - Parameters:
    ///   - card: The `Card` object to be edited.
    ///   - navigationPath: The navigation path used for managing navigation.
    init(card: Bindable<Card>, navigationPath: Binding<NavigationPath>) {
        self._card = card
        self._navigationPath = navigationPath
    }
    
    var body: some View {
        /// The main form for editing card details, divided into sections for event type, date, and card image.
        Form {
            // Event Section
            Section("Event") {
                Picker(selection: $card.eventType, label: Text("Event Type")) {
                    Text("Unknown Event Type")
                        .tag(Optional<EventType>.none)
                    
                    Divider()
                    
                    if !events.isEmpty {
                        Divider()
                        ForEach(events) { event in
                            Text(event.eventName)
                                .tag(Optional(event))
                        }
                    }
                }
                
                NavigationLink("Add New Event", destination: NewEventView())
            }
            
            // Date Section
            Section("Date") {
                DatePicker(
                    "Event Date",
                    selection: $card.cardDate,
                    displayedComponents: [.date]
                )
            }
            
            // Card Section
            Section("Card") {
                VStack {
                    NavigationLink(
                        "Select card:",
                        destination: GreetingCardsPickerView(eventType: card.eventType!, selectedGreetingCard: $card.cardFront)
                    )
                    
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
        .navigationBarTitle("\(card.recipient?.fullName ?? "Missing Name")", displayMode: .inline)
    }
}

/// A preview provider for `EditCardView`, showing a sample configuration of the view.
struct EditAnEvent_Previews: PreviewProvider {
    static var previews: some View {
        EditCardView(
            card: Bindable(
                wrappedValue: Card(
                    cardDate: Date(),
                    eventType: EventType(eventName: "Dummy Event"),
                    cardFront: GreetingCard(
                        cardName: "Sample",
                        cardFront: UIImage(named: "frontImage")?.pngData(),
                        eventType: EventType(eventName: "Sample Name"),
                        cardManufacturer: "",
                        cardURL: "https://michaelrowe01.com"
                    ),
                    recipient: Recipient(
                        addressLine1: "Line 1",
                        addressLine2: "Line 2",
                        city: "New York",
                        state: "NY",
                        zip: "01234",
                        country: "USA",
                        firstName: "First Name",
                        lastName: "Last Name",
                        category: .home
                    )
                )
            ),
            navigationPath: .constant(NavigationPath())
        )
    }
}
