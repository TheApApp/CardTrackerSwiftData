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
    @State var isIphone = IsIphone()
    
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
            ContentView()
                .modelContainer(sharedModelContainer)
                .environmentObject(isIphone)
        }
        #if os(macOS)
        .commands {
            SidebarCommands()
        }
        #endif
    }
    
    @MainActor mutating func didFinishLaunchingWithOptions() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white

        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.green,
            .font: UIFont.monospacedSystemFont(ofSize: 36, weight: .black)
        ]

        appearance.largeTitleTextAttributes = attrs

        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.accent]
    }
}
