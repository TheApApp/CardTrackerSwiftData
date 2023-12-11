//
//  EventsList.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/10/23.
//

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
                            .foregroundColor(.green)
                    } label: {
                        Text(event.eventName)
                            .foregroundColor(.green)
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
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                    })
                }
            }
        } detail: {
            Text("Select event")
                .foregroundColor(.green)
        }
        .sheet(isPresented: $newEvent) {
            NewEventView()
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
