//
//  ContentView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/10/23.
//
import SwiftUI
import SwiftData

/// The main user interface for the application, featuring a tabbed navigation layout with three tabs: Events, Gallery, and Recipients.
struct ContentView: View {
    /// Accesses the shared model context for data persistence using SwiftData.
    @Environment(\.modelContext) private var modelContext
    
    /// Controls the visibility of navigation columns in the split view.
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    
    /// Stores and restores the selected tab state. Defaults to `ListView.events`.
    @AppStorage("initial_tab", store: .standard) var listView: ListView = ListView.events
    
    /// Manages the navigation path for dynamic navigation in views.
    @State private var navigationPath = NavigationPath()
    
    /// Stores the current search query text for filtering content.
    @State private var searchText = ""
    
    /// Tracks whether the modal sheet for adding a new item is presented.
    @State private var addItem = false
    
    var body: some View {
        /// The main content view containing a `TabView` with three tabs: Events, Gallery, and Recipients.
        TabView(selection: $listView) {
            // Events Tab
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
            
            // Gallery Tab
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
            
            // Recipients Tab
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
            /// Dynamically presents a modal sheet based on the current tab.
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
