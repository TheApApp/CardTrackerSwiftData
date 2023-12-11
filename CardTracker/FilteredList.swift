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
    
    @Query(sort: \EventType.eventName) private var events: [EventType]
    @Query(sort: [SortDescriptor(\Recipient.lastName), SortDescriptor(\Recipient.firstName)]) private var recipients: [Recipient]
    
    private var eventList = false
    
    init(searchString: String, eventList: Bool) {
        self.eventList = eventList
        
        _events = Query(filter: #Predicate {
            if searchString.isEmpty {
                return true
            } else {
                return $0.eventName.localizedStandardContains(searchString)
            }
        }, sort: \EventType.eventName)
        _recipients = Query(filter: #Predicate {
            if searchString.isEmpty {
                return true
            } else {
                return $0.lastName.localizedStandardContains(searchString) || $0.firstName.localizedStandardContains(searchString)
            }
        }, sort: [SortDescriptor(\Recipient.lastName), SortDescriptor(\Recipient.firstName)])
    }
    
    var body: some View {
        List {
            if eventList {
                ForEach(events, id: \.self) { event in
                    NavigationLink(destination:
                                    //                                    ViewEventsView(recipient: recipient)
                                   Text("Event \(event.eventName)")
                    ) {
                        Text("\(event.eventName)")
                            .foregroundColor(Color(red: 0.138, green: 0.545, blue: 0.282))
                    }
                }
                .onDelete(perform: deleteEvent)
            } else {
                ForEach(recipients, id: \.self) { recipient in
                    NavigationLink(destination:
                                    //                                    ViewEventsView(recipient: recipient)
                                   Text("Recipient \(recipient.fullName)")
                    ) {
                        Text("\(recipient.fullName)")
                            .foregroundColor(Color(red: 0.138, green: 0.545, blue: 0.282))
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
            let event = events[index]
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

#Preview {
    FilteredList(searchString: "", eventList: false)
        .modelContainer(for: [EventType.self, Recipient.self])
}
