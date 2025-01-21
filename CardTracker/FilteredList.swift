//
//  FilteredList.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/10/23.
//
/// FilteredList is a view that managed the various supported lists. There are currently three types supported:
/// .events - which calls ViewEventsView
/// .greetingCard - which calls ViewGreetingCardView
/// .recipients - which calls ViewRecipientView
///
/// FilteredLists is used by ContentView to support different Tabs used by the main application interface.

import SwiftData
import SwiftUI

struct FilteredList: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \EventType.eventName) private var eventTypes: [EventType]
    @Query(sort: [SortDescriptor(\Recipient.lastName), SortDescriptor(\Recipient.firstName)]) private var recipients: [Recipient]
    
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
        _recipients = Query(filter: #Predicate {
            if searchText.isEmpty {
                return true
            } else {
                return $0.lastName.localizedStandardContains(searchText) || $0.firstName.localizedStandardContains(searchText)
            }
        }, sort: [SortDescriptor(\Recipient.lastName), SortDescriptor(\Recipient.firstName)])
        
        self._navigationPath = navigationPath
    }
 
    var body: some View {
        List {
            switch listView {
            case .events:
                ForEach(eventTypes, id: \.self) { eventType in
                    NavigationLink(destination:
                        ViewEventsView(eventType: eventType, navigationPath: $navigationPath)
                    ) {
                        Text("\(eventType.eventName)")
                            .foregroundColor(Color("ListColor"))
                    }
                }
                .onDelete(perform: deleteEvent)
            case .greetingCard:
                ForEach(eventTypes, id: \.self) { eventType in
                    NavigationLink(destination:
                        ViewGreetingCardsView(eventType: eventType, navigationPath: $navigationPath)
                    ) {
                        Text("\(eventType.eventName)")
                            .foregroundColor(Color("ListColor"))
                    }
                }
            case .recipients:
                ForEach(recipients, id: \.self) { recipient in
                    NavigationLink(destination:
                        ViewRecipientView(recipient: recipient, navigationPath: $navigationPath)
                    ) {
                        Text("\(recipient.fullName)")
                            .foregroundColor(Color("ListColor"))
                    }
                }
                .onDelete(perform: deleteRecipient)
            }
        }
    }
    
    func deleteRecipient(offsets: IndexSet) {
        
        for index in offsets {
            let recipient = recipients[index]
            modelContext.delete(recipient)
        }
        do {
            try modelContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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

#Preview("Events") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: EventType.self, configurations: config)

    for i in 1..<10 {
        let event = EventType(eventName: "Example Event \(i)")
        container.mainContext.insert(event)
    }

    return FilteredList(searchText: "", listView: .events, navigationPath: .constant(NavigationPath()))
        .modelContainer(container)
}

#Preview("Card Gallery") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: EventType.self, configurations: config)

    for i in 1..<10 {
        let event = EventType(eventName: "Example Event for Cards \(i)")
        container.mainContext.insert(event)
    }

    return FilteredList(searchText: "", listView: .greetingCard, navigationPath: .constant(NavigationPath()))
        .modelContainer(container)
}

#Preview("Recipients") {
    let configRecipient = ModelConfiguration(isStoredInMemoryOnly: true)
    let containerRecipient = try! ModelContainer(for: Recipient.self, configurations: configRecipient)

    for i in 1..<10 {
        let recipient = Recipient(addressLine1: "3494 Kuhl Avenue", addressLine2: "", city: "Atlanta", state: "GA", zip: "30303", country: "USA", firstName: "John \(i)", lastName: "AppleSeed", category: .work)
        containerRecipient.mainContext.insert(recipient)
    }

    return FilteredList(searchText: "", listView: .recipients, navigationPath: .constant(NavigationPath()))
        .modelContainer(containerRecipient)
}
