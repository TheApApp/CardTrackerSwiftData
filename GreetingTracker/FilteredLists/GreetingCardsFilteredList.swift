//
//  FilteredList.swift
//  GreetingTracker
//
//  Created by Michael Rowe on 12/10/23.
//
/// FilteredList is a view that managed the various supported lists. There are currently three types supported:
/// .events - which calls ViewEventsView
/// .greetingCard - which calls ViewGreetingCardView
/// .recipients - which calls ViewRecipientDetailsView
///
/// FilteredLists is used by ContentView to support different Tabs used by the main application interface.

import SwiftData
import SwiftUI

struct GreetingCardsFilteredList: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \EventType.eventName) private var eventTypes: [EventType]
    
    @Binding var navigationPath: NavigationPath
    
    private var listView: ListView
    
    init(searchText: String, listView: ListView, navigationPath: Binding<NavigationPath>) {
        self.listView = listView
        
        _eventTypes = Query(filter: #Predicate {
            if searchText.isEmpty {
                return true
            } else {
                return $0.eventName.localizedStandardContains(searchText)
            }
        }, sort: \EventType.eventName)
        
        self._navigationPath = navigationPath
    }
    
    var body: some View {
        List {
            ForEach(eventTypes, id: \.self) { eventType in
                NavigationLink(destination:
                                ViewGreetingCardsView(eventType: eventType, navigationPath: $navigationPath)
                ) {
                    Text("\(eventType.eventName)")
                        .foregroundColor(Color("ListColor"))
                }
            }
        }
    }
    
    func deleteEvent(offsets: IndexSet) {
        
        for index in offsets {
            let event = eventTypes[index]
            modelContext.delete(event)
        }
        do {
            try modelContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

#Preview("Card Gallery") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: EventType.self, configurations: config)
    
    for i in 1..<10 {
        let event = EventType(eventName: "Example Event for Cards \(i)")
        container.mainContext.insert(event)
    }
    
    return GreetingCardsFilteredList(searchText: "", listView: .greetingCard, navigationPath: .constant(NavigationPath()))
        .modelContainer(container)
}
