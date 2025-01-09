//
//  EditEventView.swift
//  CardTracker
//
//  Created by Michael Rowe on 1/6/24.
//

import SwiftData
import SwiftUI

struct EventTypeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var eventType: EventType?
    
    @State private var eventName = ""

    private var editorTitle: String {
        eventType == nil ? "Add Occasion" : "Edit Occasion"
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Description") {
                    TextField("Occasion Name", text: $eventName)
                        .customTextField()
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(editorTitle)
                        .font(Font.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(.accentColor)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        withAnimation {
                            save()
                            dismiss()
                        }
                    } label: {
                        Text("Save")
                    }
                    .disabled($eventName.wrappedValue == "")
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
            
            .onAppear {
                if let eventType {
                    // edit the incoming EventType
                    eventName = eventType.eventName
                }
            }
            
            #if os(macOS)
            .padding()
            #endif
        }
    }
    
    private func save() {
        if let eventType {
            eventType.eventName = eventName
        } else {
            let newEventType = EventType(eventName: eventName)
            modelContext.insert(newEventType)
        }
    }
}

#Preview("Add Event Type") {
     let config = ModelConfiguration(isStoredInMemoryOnly: true)
     let container = try! ModelContainer(for: EventType.self, configurations: config)
     let event: EventType? = nil
    
    return EventTypeView(eventType: event)
         .modelContainer(container)
}

#Preview("Edit Event Type") {
     let config = ModelConfiguration(isStoredInMemoryOnly: true)
     let container = try! ModelContainer(for: EventType.self, configurations: config)
     let event = EventType(eventName: "Event Name")
    
    return EventTypeView(eventType: event)
         .modelContainer(container)
}

