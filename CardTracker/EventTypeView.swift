//
//  EventTypeView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/16/23.
//

import SwiftUI

struct EventTypeView: View {
    var eventType: EventType
    var isCards: Bool = false
    private var iPhone = false
    
    init(eventType: EventType, isCards: Bool) {
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
        self.eventType = eventType
        self.isCards = isCards
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                if isCards {
                    Text("\(eventType.eventName) Gallery")
                        .font(.title)
                } else {
                    Text("\(eventType.eventName) Cards Sent")
                        .font(.title)
                }
                Spacer()
            }
            Spacer()
        }
        .scaledToFill()
        .foregroundColor(.accentColor)
        .padding([.leading, .trailing], 10 )
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return EventTypeView(eventType: previewer.eventType, isCards: false)
        
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
