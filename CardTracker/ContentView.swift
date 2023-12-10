//
//  ContentView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/10/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var recipients: [Recipient]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(recipients) { recipient in
                    NavigationLink {
                        Text("Recipient named \(recipient.fullName)")
                    } label: {
                        Text(recipient.fullName)
                    }
                }
                .onDelete(perform: deleteItems)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addRecipient) {
                        Label("Add Recipient", systemImage: "plus.circle.fill")
                    }
                }
            }
        } detail: {
            Text("Select a recipient")
        }
    }

    private func addRecipient() {
        withAnimation {
            let newRecipient = Recipient(addressLine1: "5017 Wineberry Drive", addressLine2: "", city: "Durham", state: "NC", zip: "27713-8535", country: "USA", firstName: "Michael", lastName: "Rowe")
            modelContext.insert(newRecipient)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(recipients[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Recipient.self, inMemory: true)
}
