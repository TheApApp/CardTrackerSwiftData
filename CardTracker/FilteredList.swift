//
//  FilteredList.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/10/23.
//

import SwiftData
import SwiftUI

struct FilteredList: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \EventType.eventName) private var events: [EventType]
    @Query(sort: [SortDescriptor(\Recipient.lastName), SortDescriptor(\Recipient.firstName)]) private var recipients: [Recipient]
    
    private var eventList = false
    
    init(filter: String, eventList: Bool) {
        self.eventList = eventList
        if filter.isEmpty {

        }
    }
    
    var body: some View {
        List {
            if eventList {
                ForEach(events) { event in
                    HStack {
                        Text(event.eventName)
                        Spacer()
                    }
                }
            } else {
                ForEach(recipients) { recipient in
                    HStack {
                        Text(recipient.fullName)
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    FilteredList(filter: "", eventList: false)
        .modelContainer(for: [EventType.self, Recipient.self])
}
