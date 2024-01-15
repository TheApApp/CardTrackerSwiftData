//
//  FilteredList.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/10/23.
//

import SwiftData
import SwiftUI

struct FilteredList: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \EventType.eventName) private var eventTypes: [EventType]
    @Query(sort: [SortDescriptor(\Recipient.lastName), SortDescriptor(\Recipient.firstName)]) private var recipients: [Recipient]
    
    @Binding var navigationPath: NavigationPath
    
    private var listView: ListView
    
    init(searchText: String, listView: ListView, navigationPath: Binding<NavigationPath>) {
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
                        ViewCardsView(eventType: eventType, navigationPath: $navigationPath)
                    ) {
                        Text("\(eventType.eventName)")
                            .foregroundColor(.green)
                    }
                }
                .onDelete(perform: deleteEvent)
            case .recipients:
                ForEach(recipients, id: \.self) { recipient in
                    NavigationLink(destination:
                        ViewEventsView(recipient: recipient, navigationPath: $navigationPath)
                    ) {
                        Text("\(recipient.fullName)")
                            .foregroundColor(.green)
                    }
                }
                .onDelete(perform: deleteRecipient)
            case .greetingCard:
                ForEach(eventTypes, id: \.self) { eventType in
                    NavigationLink(destination:
                        ViewGreetingCardsView(eventType: eventType, navigationPath: $navigationPath)
                    ) {
                        Text("\(eventType.eventName)")
                            .foregroundColor(.green)
                    }
                }
                .onDelete(perform: deleteGreetingCards)
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
    
    func deleteGreetingCards(offsets: IndexSet) {
        
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
}

//#Preview {
//    FilteredList(searchText: "", listView: ListView.recipients, navigationPath: .constant(NavigationPath()))
//        .modelContainer(for: [EventType.self, Recipient.self])
//}
