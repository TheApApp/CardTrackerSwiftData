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
    
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    @State private var listView: ListView = ListView.recipients
    @State private var navigationPath = NavigationPath()
    @State private var searchText = ""
    
    @State private var addItem = false
    
    var body: some View {
        TabView {
            NavigationView {
                FilteredList(searchText: searchText, listView: .events, navigationPath: $navigationPath)
                    .searchable(text: $searchText)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                                Text("Events")
                                    .foregroundColor(.green)
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                listView = .events
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
            }
            .tabItem {
                Image(systemName: "calendar")
                Text("Events")
                    .foregroundColor(.green)
            }
            NavigationView {
                FilteredList(searchText: searchText, listView: .greetingCard, navigationPath: $navigationPath)
                    .searchable(text: $searchText)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                                Text("Gallery")
                                    .foregroundColor(.green)
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                listView = .greetingCard
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
            }
            .tabItem {
                Image(systemName: "photo.stack")
                Text("Gallery")
                    .foregroundColor(.green)
            }
            NavigationView {
                FilteredList(searchText: searchText, listView: .recipients, navigationPath: $navigationPath)
                    .searchable(text: $searchText)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                                Text("Recipient")
                                    .foregroundColor(.green)
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                listView = .recipients
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
            }
            .tabItem {
                Image(systemName: "person.crop.circle")
                Text("Receipients")
                    .foregroundColor(.green)
            }
        }
//        NavigationSplitView(columnVisibility: $columnVisibility) {
//            List {
//                Button(action: {
//                    listView = .events
//                }, label: {
//                    Text("Events")
//                        .foregroundColor(.green)
//                })
//                
//                Button(action: {
//                    listView = .greetingCard
//                }, label: {
//                    Text("Greeting Cards")
//                        .foregroundColor(.green)
//                })
//                
//                Button(action: {
//                    listView = .recipients
//                }, label: {
//                    Text("Recipients")
//                        .foregroundColor(.green)
//                })
//            }
//            .listStyle(.automatic)
//        } content: {
//            FilteredList(searchText: searchText, listView: listView, navigationPath: $navigationPath)
//                .searchable(text: $searchText)
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        switch listView {
//                        case .events:
//                            Text("Events")
//                                .foregroundColor(.green)
//                        case .greetingCard:
//                            Text("Gallery")
//                                .foregroundColor(.green)
//                        case .recipients:
//                            Text("Recipients")
//                                .foregroundColor(.green)
//                        }
//                    }
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button(action: {
//                            self.addItem.toggle()
//                        }, label: {
//                            Image(systemName: "plus.circle")
//                                .font(.title2)
//                                .foregroundColor(.green)
//                        })
//                    }
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        EditButton()
//                            .foregroundColor(.green)
//                    }
//                }
//        } detail: {
//            Text("Make a selection")
//                .font(.title)
//                .foregroundColor(.green)
//        }
//        .navigationSplitViewStyle(.automatic)
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
    
//    func addRecipient() {
//        
//        switch listView {
//        case .events:
//            let eventType = EventType(eventName: "")
//            modelContext.insert(eventType)
//            // push to the recipient in the stack
//            navigationPath.append(eventType)
//        case .recipients:
//            let recipient = Recipient(addressLine1: "", addressLine2: "", city: "", state: "", zip: "", country: "", firstName: "", lastName: "")
//            modelContext.insert(recipient)
//            // push to the recipient in the stack
//            navigationPath.append(recipient)
//        case .greetingCard:
//            let greetingCard = GreetingCard(cardName: "", cardFront: nil, eventType: nil, cardManufacturer: "", cardURL: "")
//            modelContext.insert(greetingCard)
//            // push to the recipient in the stack
//            navigationPath.append(greetingCard)
//        }
//    }
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
