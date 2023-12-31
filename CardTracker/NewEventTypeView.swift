//
//  NewEventTypeView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/10/23.
//

import os
import SwiftData
import SwiftUI

struct NewEventTypeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var eventName: String = ""
    
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
            Section(header: Text("Event")){
                VStack {
                    TextField("Event Name", text: $eventName)
                        .customTextField()
                    Spacer()
                }
            }
        }
    }
    
    func saveEventType() {
        let logger=Logger(subsystem: "com.theapapp.cardtracker", category: "NewRecipientView.SaveEventType")
        logger.log("Saving...")
        if eventName != "" {
            let eventType = EventType(eventName: eventName)
            modelContext.insert(eventType)
        }
        do {
            try modelContext.save()
        } catch let error as NSError {
            logger.log("Save error: \(error), \(error.userInfo)")
        }
    }
}

#Preview {
    NewEventTypeView()
}
