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
    @State private var selected = false
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
        NavigationSplitView {
            List(ListView.allCases) { listView in
                Text(listView.rawValue).tag(listView)
                    .textCase(.uppercase)
                    .foregroundColor(.green)
                    .onTapGesture {
                        self.listView = listView
                    }
            }
            .listStyle(.sidebar)
        } content: {
            FilteredList(searchString: searchString, listView: listView)
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
        } detail: {
            Text("Make a selection")
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
}

#Preview {
    ContentView()
        .modelContainer(for: Recipient.self, inMemory: true)
}
