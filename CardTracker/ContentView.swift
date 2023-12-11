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
    
    @State var eventList = false
    @State var newEvent = false
    @State var newRecipient = false
    @State private var nameFilter = ""
    @Query private var recipients: [Recipient]

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                /// todo: change to Searchable
                TextField("Filter", text: $nameFilter)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.top, .leading, .trailing, .bottom])
                    .background(Color(UIColor.systemGroupedBackground))
                FilteredList(filter: nameFilter, eventList: eventList)
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.eventList.toggle()
                    }, label: {
                        Image(systemName: eventList ? "person.crop.circle" : "calendar.circle")
                            .font(.title2)
                            .foregroundColor(.green)
                    })
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if eventList {
                            self.newEvent.toggle()
                        } else {
                            self.newRecipient.toggle()
                        }
                    }, label: {
                        Image(systemName: "plus.circle")
                            .font(.title2)
                            .foregroundColor(.green)
                    })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            if eventList {
                Text("Select an Event")
                    .font(.largeTitle)
                    .foregroundColor(.green)
            } else {
                Text("Select a Recipient")
                    .font(.largeTitle)
                    .foregroundColor(.green)
            }
        }
        .navigationViewStyle(.automatic)
        .ignoresSafeArea(.all)
        .sheet(isPresented: $newRecipient) {
            NewRecipientView()
        }
        .sheet(isPresented: $newEvent) {
            NewEventView()
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
