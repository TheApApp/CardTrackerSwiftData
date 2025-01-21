//
//  GreetKeeperApp.swift
//  GreetingTracker
//
//  Created by Michael Rowe on 12/10/23.
//

import os
import SwiftUI
import SwiftData

/// Greeting Tracker is an application developed by Michael Rowe as a means of tracking all the various greeting cards sent out each year.  There are four major objects in this application: Cards, EventTypes, GreetingCards, and Recipients.  Each of these are defined as SwiftData classes.
@main
struct GreetKeeperApp: App {
    @State var isIphone = IsIphone()
    
    let logger=Logger(subsystem: "com.theapapp.CardTracker", category: "State Changes")
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
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.green,
            .font: UIFont.monospacedSystemFont(ofSize: 20, weight: .black)
        ]
        
        appearance.largeTitleTextAttributes = attrs
        
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.accentColor) // Use your asset color
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.systemGray], for: .normal)
        UINavigationBar.appearance().barTintColor = UIColor(Color.accentColor)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: Color.accentColor]
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = UIColor(Color.accentColor)
    }
    
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
                .environmentObject(isIphone)
                .onChange(of: scenePhase) {
                    print("scenePhase \(scenePhase)")
                }
        }
#if os(macOS)
        .commands {
            SidebarCommands()
        }
#endif
    
    }
}
