//
//  EventTypeView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/16/23.
//

import SwiftUI

struct EventTypeView: View {
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
        
        return EventTypeView(title: previewer.eventType.eventName, isCards: false)
        
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
