//
//  EditEventView.swift
//  CardTracker
//
//  Created by Michael Rowe on 1/6/24.
//

import SwiftData
import SwiftUI

struct EditEventTypeView: View {
    @Environment(\.modelContext) var modelContext
    
    @Bindable var eventType: EventType
    
    init(eventType: Bindable<EventType>) {
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
        
        self._eventType = eventType
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Description") {
                    TextField("Event Name", text: $eventType.eventName)
                        .customTextField()
                }
            }
            .navigationTitle("Event Information")
        }
    }
}
//
//#Preview {
//    do {
//        let previewer = try Previewer()
//        
//        return EditEventTypeView(eventType: Bindable<EventType>(previewer.eventType))
//    } catch {
//        return Text("Failed to create preview: \(error.localizedDescription)")
//    }
//}
