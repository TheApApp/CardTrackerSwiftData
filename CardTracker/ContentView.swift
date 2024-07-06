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
    @AppStorage("initial_tab", store: .standard) var listView: ListView = ListView.events
    @State private var navigationPath = NavigationPath()
    @State private var searchText = ""
    
    @State private var addItem = false
    
    var body: some View {
        TabView(selection: $listView) {
            NavigationView {
                FilteredList(searchText: searchText, listView: .events, navigationPath: $navigationPath)
                    .searchable(text: $searchText)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                                Text("Events")
                                    .foregroundColor(.accentColor)
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                listView = .events
                                self.addItem.toggle()
                            }, label: {
                                Image(systemName: "plus.circle")
                                    .font(.title2)
                                    .foregroundColor(.accentColor)
                            })
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            EditButton()
                                .foregroundColor(.accentColor)
                        }
                    }
            }
            .tabItem {
                Image(systemName: "calendar")
                Text("Events")
                    .foregroundColor(.accentColor)
            }
            .tag(ListView.events)
            NavigationView {
                FilteredList(searchText: searchText, listView: .greetingCard, navigationPath: $navigationPath)
                    .searchable(text: $searchText)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                                Text("Gallery")
                                    .foregroundColor(.accentColor)
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                listView = .greetingCard
                                self.addItem.toggle()
                            }, label: {
                                Image(systemName: "plus.circle")
                                    .font(.title2)
                                    .foregroundColor(.accentColor)
                            })
                        }
                    }
            }
            .tabItem {
                Image(systemName: "photo.stack")
                Text("Gallery")
                    .foregroundColor(.accentColor)
            }
            .tag(ListView.greetingCard)
            NavigationView {
                FilteredList(searchText: searchText, listView: .recipients, navigationPath: $navigationPath)
                    .searchable(text: $searchText)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                                Text("Recipient")
                                    .foregroundColor(.accentColor)
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                listView = .recipients
                                self.addItem.toggle()
                            }, label: {
                                Image(systemName: "plus.circle")
                                    .font(.title2)
                                    .foregroundColor(.accentColor)
                            })
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            EditButton()
                                .foregroundColor(.accentColor)
                        }
                    }
            }
            .tabItem {
                Image(systemName: "person.crop.circle")
                Text("Recipients")
                    .foregroundColor(.accentColor)
            }
            .tag(ListView.recipients)
        }
        .sheet(isPresented: $addItem) {
            switch listView {
            case .events:
                EditEventTypeView(eventType: nil)
            case .recipients:
                NewRecipientView()
            case .greetingCard:
                EditGreetingCardView(greetingCard: nil)
            }
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
