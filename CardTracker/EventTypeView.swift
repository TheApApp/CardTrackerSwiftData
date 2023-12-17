//
//  EventTypeView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/16/23.
//

import SwiftUI

struct EventTypeView: View {
    var eventType: EventType
    private var iPhone = false
    
    init(eventType: EventType) {
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
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("\(eventType.eventName) Cards")
                    .font(.title)
                Spacer()
            }
            Spacer()
        }
        .scaledToFill()
        .foregroundColor(.accentColor)
        .padding([.leading, .trailing], 10 )
    }
}
