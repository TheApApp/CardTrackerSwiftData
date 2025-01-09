//
//  NewEventView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/10/23.
//

/// DEPRECIATED and removed from build

import os
import SwiftData
import SwiftUI

struct NewEventView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    
    @State private var eventName: String = ""
    
    @State var presentAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Description") {
                    TextField("Occasion Name", text: $eventName)
                        .customTextField()
                }
            }
            .padding([.leading, .trailing], 10 )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Occasion Information")
                        .font(Font.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundColor(.accentColor)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        withAnimation {
                            saveEvent()
                            dismiss()
                        }
                    } label: {
                        Text("Save")
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    func saveEvent() {
        let logger=Logger(subsystem: "com.theapapp.cardtracker", category: "EVentView.SaveEvent")
        logger.log("Saving...")
        if eventName != "" {
            let event = EventType(eventName: eventName)
            modelContext.insert(event)
        }
        do {
            try modelContext.save()
        } catch let error as NSError {
            logger.log("Save error: \(error), \(error.userInfo)")
        }
    }
}

#Preview {
    NewEventView()
}
