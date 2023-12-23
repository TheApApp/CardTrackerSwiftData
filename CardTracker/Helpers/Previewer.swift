//
//  Previewer.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/22/23.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
struct Previewer {
    let container: ModelContainer
    let card: Card
    let eventType: EventType
    let greetingCard: GreetingCard
    let recipient: Recipient
    
    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Recipient.self, configurations: config)
        
        eventType = EventType(eventName: "Christmas")
        greetingCard = GreetingCard(cardName: "Sample Card", cardFront: UIImage(named: "frontImage")!.pngData()! , eventType: eventType, cardURL: URL(string: "https://michaelrowe01.com"))
        recipient = Recipient(addressLine1: "1 Apple Park Way", addressLine2: "", city: "Cupertino", state: "CA", zip: "95014", country: "USA", firstName: "Steve", lastName: "Jobs")
        card = Card(cardDate: Date(), eventType: eventType, cardFront: greetingCard, recipient: recipient)
        
        container.mainContext.insert(card)
    }
}
