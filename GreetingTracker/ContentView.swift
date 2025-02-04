//
//  ContentView.swift
//  GreetingTracker
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
    
    /// Adding a WalkThru launch screen  Will alllow for a reset to do the walkthu again
    @AppStorage("walkthrough") var walkthrough = 1
    @AppStorage("totalViews") var totalViews = 5
    @State var eventType: EventType? 
    
    var body: some View {
        
        if walkthrough == 1 {
            WalkThroughtView(title: "Welcome to Greeting Tracker", description: "Never send the same card twice", bgColor: "AccentColor", img: "Welcome_one", eventType: $eventType)
        } else if walkthrough == 2 {
            WalkThroughtView(title: "Occasions", description: "Let's define your first occasion.", bgColor: "AccentColor", img: "Welcome_two", eventType: $eventType)
        } else if walkthrough == 3 {
            WalkThroughtView(title: "Greeting Cards", description: "Now let's add a card for that type of occasion.", bgColor: "AccentColor", img: "Welcome_three", eventType: $eventType)
        } else if walkthrough == 4 {
            WalkThroughtView(title: "Recipients", description: "Then add a recipient to receive cards.", bgColor: "AccentColor", img: "Welcome_four", eventType: $eventType)
        } else if walkthrough == 5 {
            WalkThroughtView(title: "Putting it together", description: "Finally, add a card to a recipient.", bgColor: "AccentColor", img: "Welcome_five", eventType: $eventType)
        } else {
            /// The main content view containing a `TabView` with three tabs: Events, Gallery, and Recipients.
            TabView(selection: $listView) {
                // Events Tab
                NavigationView {
                    EventsFilteredList(searchText: searchText, listView: .events, navigationPath: $navigationPath)
                        .searchable(text: $searchText)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Text("Occasions")
                                    .foregroundColor(Color("AccentColor"))
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    listView = .events
                                    self.addItem.toggle()
                                }, label: {
                                    Image(systemName: "plus")
                                        .font(.title2)
                                        .tint(Color("AccentColor"))
                                })
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                EditButton()
                                    .tint(Color("AccentColor"))
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    walkthrough = 2
                                }, label: {
                                    Image(systemName: "questionmark.circle")
                                        .font(.title2)
                                        .tint(Color("AccentColor"))
                                })
                            }
                        }
                }
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Occasions")
                }
                .tag(ListView.events)
                
                // Gallery Tab
                NavigationView {
                    GreetingCardsFilteredList(searchText: searchText, listView: .greetingCard, navigationPath: $navigationPath)
                        .searchable(text: $searchText)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Text("Card Gallery")
                                    .foregroundColor(Color("AccentColor"))
                                
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    listView = .greetingCard
                                    self.addItem.toggle()
                                }, label: {
                                    Image(systemName: "plus")
                                        .font(.title2)
                                        .tint(Color("AccentColor"))
                                })
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                EditButton()
                                    .tint(Color("AccentColor"))
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    walkthrough = 3
                                }, label: {
                                    Image(systemName: "questionmark.circle")
                                        .font(.title2)
                                        .tint(Color("AccentColor"))
                                })
                            }
                        }
                }
                .tabItem {
                    Image(systemName: "photo.stack")
                    Text("Card Gallery")
                }
                .tag(ListView.greetingCard)
                
                // Recipients Tab
                NavigationView {
                    RecipientsFilteredList(searchText: searchText, listView: .recipients, navigationPath: $navigationPath)
                        .searchable(text: $searchText)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Text("Recipient")
                                    .foregroundColor(Color("AccentColor"))
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    listView = .recipients
                                    self.addItem.toggle()
                                }, label: {
                                    Image(systemName: "plus")
                                        .font(.title2)
                                        .tint(Color("AccentColor"))
                                })
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                EditButton()
                                    .tint(Color("AccentColor"))
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    walkthrough = 4
                                }, label: {
                                    Image(systemName: "questionmark.circle")
                                        .font(.title2)
                                        .tint(Color("AccentColor"))
                                })
                            }
                        }
                        .tint(Color("AccentColor"))
                }
                .tabItem {
                    Image(systemName: "person.crop.rectangle.fill")
                    Text("Recipients")
                }
                .tag(ListView.recipients)
            }
            .tabViewStyle(.automatic)
            .accentColor(Color("AccentColor"))
            .sheet(isPresented: $addItem) {
                /// Dynamically presents a modal sheet based on the current tab.
                switch listView {
                case .events:
                    EventTypeView(eventType: nil)
                        .interactiveDismissDisabled(true)
                case .greetingCard:
                    EditGreetingCardView(greetingCard: nil)
                        .interactiveDismissDisabled(true)
                case .recipients:
                    RecipientView()
                        .interactiveDismissDisabled(true)
                }
            }
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return ContentView().modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
