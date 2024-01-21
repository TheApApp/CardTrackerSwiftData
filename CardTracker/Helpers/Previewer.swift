//
//  Previewer.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/22/23.
//

import Foundation
import SwiftData
import SwiftUI

/// The purpose of this struct is setting up and managing a preview scenario for a greeting card, including the recipient's information, event type, and card details.
/// The Core Data container (ModelContainer) is used to manage the data models, and the @MainActor attribute ensures that the struct's methods are accessed from the main thread for thread safety.
///
/// Usage:
/// ```
/// #Preview {
///    do {
///        let previewer = try Previewer()
///
///        return CardView(cardImage: previewer.card.cardUIImage())
///    } catch {
///        return Text("Failed to create preview: \(error.localizedDescription)")
///    }
/// }
/// ```
/// In this #Preivew we create an instance of the previewer, and then utilize it's card object to pass to the CardView
///
@MainActor
struct Previewer {
    /// An instance of ModelContainer that holds a Core Data container for the data model.
    /// It is configured with a ModelConfiguration that indicates the model should be stored in memory only.
    let container: ModelContainer
    /// An instance of Card representing a greeting card. It is initialized with various parameters, including an EventType, a GreetingCard, and a Recipient.
    let card: Card
    /// An instance of EventType representing the type of event (in this case, "Christmas").
    let eventType: EventType
    /// An instance of GreetingCard representing the details of the greeting card. It includes a card name, front image data, event type, and a URL.
    let greetingCard: GreetingCard
    /// An instance of Recipient representing the recipient's address information.
    let recipient: Recipient
    

    /// The initializer starts by creating a ModelConfiguration for the Recipient model, indicating that it should be stored only in memory.
    ///
    /// It then initializes the ModelContainer for the Recipient model using the configuration.
    ///
    /// Creates an instance of EventType for the event "Christmas."
    ///
    /// Initializes a GreetingCard with a sample card name, front image data, event type, and a URL.
    ///
    /// Initializes a Recipient with address information for Steve Jobs.
    ///
    /// Initializes a Card with the current date, event type, greeting card, and recipient.
    ///
    /// Inserts the Card instance into the main context of the ModelContainer.
    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Recipient.self, configurations: config)
        
        eventType = EventType(eventName: "Christmas")
        greetingCard = GreetingCard(cardName: "Sample Card", cardFront: UIImage(named: "frontImage")!.pngData()!, eventType: eventType, cardManufacturer: "Cards Are Us", cardURL: "https://michaelrowe01.com")
        recipient = Recipient(addressLine1: "1 Apple Park Way", addressLine2: "", city: "Cupertino", state: "CA", zip: "95014", country: "USA", firstName: "Steve", lastName: "Jobs")
        card = Card(cardDate: Date(), eventType: eventType, cardFront: greetingCard, recipient: recipient)
        
        container.mainContext.insert(card)
    }
}
