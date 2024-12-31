//
//  EventTypeView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/16/23.
//
/// EventTypeView
/// This is used by the GeneratePDF to title the of the event for the Gallery or Sent Cards
/// This is also used to show the correct type in the EditEventTypeView as either a Gallery or Sent Cards

import SwiftUI

struct DisplayEventTypeView: View {
    var title: String
    var isCards: Bool = false
    
    init(title: String, isCards: Bool) {
        self.title = title
        self.isCards = isCards
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                if isCards {
                    Text("\(title) Gallery")
                        .font(.title)
                } else {
                    Text("\(title) Cards Sent")
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
        
        return DisplayEventTypeView(title: previewer.eventType.eventName, isCards: false)
        
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
