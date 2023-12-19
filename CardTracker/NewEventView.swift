//
//  NewEventView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/10/23.
//

import os
import SwiftData
import SwiftUI

struct NewEventView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var eventName: String = ""
    
    @State var presentAlert = false
    
    init() {
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
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Description") {
                    TextField("Event Name", text: $eventName)
                        .customTextField()
                }
            }
            .padding([.leading, .trailing], 10 )
            .navigationTitle("Event Information")
            .navigationBarItems(trailing:
                                    HStack {
                Button(action: {
                    saveEvent()
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "square.and.arrow.down")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                })
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.down.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                })
            }
            )
        }
    }
    
    func saveEvent() {
        let logger=Logger(subsystem: "com.theapapp.cardtracker", category: "NewRecipientView.SaveEvent")
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
