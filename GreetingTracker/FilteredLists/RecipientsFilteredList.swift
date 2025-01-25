//
//  FilteredList.swift
//  GreetingTracker
//
//  Created by Michael Rowe on 12/10/23.
//
/// FilteredList is a view that managed the various supported lists. There are currently three types supported:
/// .events - which calls ViewEventsView
/// .greetingCard - which calls ViewGreetingCardView
/// .recipients - which calls ViewRecipientDetailsView
///
/// FilteredLists is used by ContentView to support different Tabs used by the main application interface.

import SwiftData
import SwiftUI

struct RecipientsFilteredList: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: [SortDescriptor(\Recipient.lastName), SortDescriptor(\Recipient.firstName)]) private var recipients: [Recipient]
    
    @Binding var navigationPath: NavigationPath
    
    private var listView: ListView
    
    init(searchText: String, listView: ListView, navigationPath: Binding<NavigationPath>) {
        self.listView = listView
        
        _recipients = Query(filter: #Predicate {
            if searchText.isEmpty {
                return true
            } else {
                return $0.lastName.localizedStandardContains(searchText) || $0.firstName.localizedStandardContains(searchText)
            }
        }, sort: [SortDescriptor(\Recipient.lastName), SortDescriptor(\Recipient.firstName)])
        
        self._navigationPath = navigationPath
    }
    
    var body: some View {
        List {
            ForEach(recipients, id: \.self) { recipient in
                NavigationLink(destination:
                                ViewRecipientDetailsView(recipient: recipient, navigationPath: $navigationPath)
                ) {
                    Text("\(recipient.fullName)")
                        .foregroundColor(Color("ListColor"))
                }
            }
            .onDelete(perform: deleteRecipient)
        }
    }
    
    func deleteRecipient(offsets: IndexSet) {
        
        for index in offsets {
            let recipient = recipients[index]
            modelContext.delete(recipient)
        }
        do {
            try modelContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

#Preview("Recipients") {
    let configRecipient = ModelConfiguration(isStoredInMemoryOnly: true)
    let containerRecipient = try! ModelContainer(for: Recipient.self, configurations: configRecipient)
    
    for i in 1..<10 {
        let recipient = Recipient(addressLine1: "3494 Kuhl Avenue", addressLine2: "", city: "Atlanta", state: "GA", zip: "30303", country: "USA", firstName: "John \(i)", lastName: "AppleSeed", category: .work)
        containerRecipient.mainContext.insert(recipient)
    }
    
    return RecipientsFilteredList(searchText: "", listView: .recipients, navigationPath: .constant(NavigationPath()))
        .modelContainer(containerRecipient)
}
