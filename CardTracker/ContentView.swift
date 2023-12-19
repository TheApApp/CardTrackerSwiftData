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
    
    @State var listView: ListView = ListView.recipients
    @State var addItem = false
    @State private var searchString = ""
    @State var selectedTab = 0
    @Query private var recipients: [Recipient]
    
    init() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.systemGreen,
            .font: UIFont(name: "ArialRoundedMTBold", size: 35)!]
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.systemGreen,
            .font: UIFont(name: "ArialRoundedMTBold", size: 20)!]
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
    }
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                FilteredList(searchString: searchString, listView: .recipients)
                    .tabItem {
                        Label("Recipient", systemImage: "person.crop.circle")
                    }
                    .tag(0)
                FilteredList(searchString: searchString, listView: .events)
                    .tabItem {
                        Label("Event", systemImage: "calendar.circle")
                    }
                    .tag(1)
                FilteredList(searchString: searchString, listView: .greetingCard)
                    .tabItem {
                        Label("Gallery", systemImage: "photo.circle")
                    }
                    .tag(2)
            }
            .searchable(text: $searchString)
            .toolbar {
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
                }
            }
            Text("Make a selection")
                .font(.largeTitle)
                .foregroundColor(.green)
        }
        .navigationViewStyle(.automatic)
        .ignoresSafeArea(.all)
        .sheet(isPresented: $addItem) {
            switch selectedTab {
            case 1:
                NewEventView()
            case 2:
                NewGreetingCardView()
            default:
                NewRecipientView()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Recipient.self, inMemory: true)
}
