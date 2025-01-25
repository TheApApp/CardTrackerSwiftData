//
//  EventsList.swift
//  GreetingTracker
//
//  Created by Michael Rowe on 12/10/23.
//
/// EventsList provides a simple List in a NavigationSplitView of all the defined events
/// It appears to be abandonded as it is not called by any other view.
/// 
/// It support creating a new Event Type via the NewEventView()
/// It also supports deleting one or more events via the Edit button and Slide over.

import SwiftData
import SwiftUI

struct EventsList: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var events: [EventType]
    @State private var newEvent = false
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(events) { event in
                    NavigationLink {
                        Text("Event named \(event.eventName)")
                            .foregroundColor(Color("AccentColor"))
                    } label: {
                        Text(event.eventName)
                            .foregroundColor(Color("AccentColor"))
                    }
                }
                .onDelete(perform: deleteItems)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.newEvent.toggle()
                    }, label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(Color("AccentColor"))
                    })
                }
            }
        } detail: {
            Text("Select event")
                .foregroundColor(Color("AccentColor"))
        }
        .sheet(isPresented: $newEvent) {
            EventTypeView()
                .interactiveDismissDisabled(true)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(events[index])
            }
        }
    }
}

#Preview {
    EventsList()
        .modelContainer(for: EventType.self)
}
