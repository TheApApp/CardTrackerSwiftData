//
//  CardTrackerApp.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/10/23.
//

import SwiftUI
import SwiftData

@main
struct CardTrackerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Card.self,
            Event.self,
            Recipient.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
