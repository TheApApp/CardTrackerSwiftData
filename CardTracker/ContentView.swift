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
    
    @State private var listView: ListView = ListView.recipients
    @State private var navigationPath = NavigationPath()
    @State private var searchText = ""
    
    @State private var addItem = false
    
    var body: some View {
        //        NavigationStack(path: $navigationPath) {
        //            List {
        //
        //            FilteredList(searchText: searchText, listView: listView, navigationPath: $navigationPath)
        //                .navigationTitle("Greeting Card Tracker")
        //                .navigationDestination(for: Recipient.self) { recipient in
        //                    EditRecipientView(recipient: Bindable(wrappedValue: recipient), navigationPath: $navigationPath)
        //                }
        //                .toolbar {
        //                    Menu("List", systemImage: "list.bullet") {
        //                        Picker("ListView", selection: $listView ) {
        //                            Text("Recipient")
        //                                .tag(ListView.recipients)
        //                            Text("Events")
        //                                .tag(ListView.events)
        //                            Text("Greeting Cards")
        //                                .tag(ListView.greetingCard)
        //                        }
        //                    }
        //                    Button("Add", systemImage: "plus", action: addRecipient)
        //                    EditButton()
        //                }
        //                .searchable(text: $searchText)
        //        }
        
        NavigationSplitView {
            //            List(ListView.allCases) { listView in
            //                Text(listView.rawValue).tag(listView)
            //                    .textCase(.lowercase)
            //                    .foregroundColor(.green)
            //                    .onTapGesture {
            //                        self.listView = listView
            //                    }
            //            }
            List {
                Button(action: {
                    listView = .events
                }, label: {
                    Text("Events")
                        .foregroundColor(.green)
                })
                
                Button(action: {
                    listView = .greetingCard
                }, label: {
                    Text("Greeting Cards")
                        .foregroundColor(.green)
                })
                
                Button(action: {
                    listView = .recipients
                }, label: {
                    Text("Recipients")
                        .foregroundColor(.green)
                })
            }
            .listStyle(.sidebar)
        } content: {
            FilteredList(searchText: searchText, listView: listView, navigationPath: $navigationPath)
                .searchable(text: $searchText)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        switch listView {
                        case .events:
                            Text("Events")
                                .foregroundColor(.green)
                        case .greetingCard:
                            Text("Gallery")
                                .foregroundColor(.green)
                        case .recipients:
                            Text("Recipients")
                                .foregroundColor(.green)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            self.addItem.toggle()
                        }, label: {
                            Image(systemName: "plus.circle")
                                .font(.title2)
                                .foregroundColor(.green)
                        })
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                            .foregroundColor(.green)
                    }
                }
        } detail: {
            Text("Make a selection")
                .font(.title)
                .foregroundColor(.green)
        }
        .navigationSplitViewStyle(.balanced)
        .sheet(isPresented: $addItem) {
            switch listView {
            case .events:
                NewEventView()
            case .recipients:
                NewRecipientView()
            case .greetingCard:
                NewGreetingCardView()
            }
        }
    }
    
    func addRecipient() {
        
        switch listView {
        case .events:
            let eventType = EventType(eventName: "")
            modelContext.insert(eventType)
            // push to the recipient in the stack
            navigationPath.append(eventType)
        case .recipients:
            let recipient = Recipient(addressLine1: "", addressLine2: "", city: "", state: "", zip: "", country: "", firstName: "", lastName: "")
            modelContext.insert(recipient)
            // push to the recipient in the stack
            navigationPath.append(recipient)
        case .greetingCard:
            let greetingCard = GreetingCard(cardName: "", cardFront: nil, eventType: nil, cardURL: nil)
            modelContext.insert(greetingCard)
            // push to the recipient in the stack
            navigationPath.append(greetingCard)
        }
        
    }
}
//
//#Preview {
//    do {
//        let previewer = try Previewer()
//
//        return ContentView().modelContainer(previewer.container)
//    } catch {
//        return Text("Failed to create preview: \(error.localizedDescription)")
//    }
//}
