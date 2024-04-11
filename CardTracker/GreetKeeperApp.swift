//
//  GreetKeeperApp.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/10/23.
//

import SwiftUI
import SwiftData

/// Card Tracker is an application developed by Michael Rowe as a means of tracking all the various greeting cards sent out each year.  There are four major objects in this application: Cards, EventTypes, GreetingCards, and Recipients.  Each of these are defined as SwiftData classes.
@main
struct GreetKeeperApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Card.self,
            EventType.self,
            Recipient.self,
            GreetingCard.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false, cloudKitDatabase: .automatic )
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView(container: sharedModelContainer)
        }
//        .modelContainer(sharedModelContainer)
        #if os(macOS)
        .commands {
            SidebarCommands()
        }
        #endif
    }
}
