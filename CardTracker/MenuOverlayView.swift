//
//  MenuOverlayView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/11/23.
//

import os
import SwiftData
import SwiftUI

/// MenuOverLayView - This allows for card to have a set of functions that are able to be executed on them.
///
/// Supported Features;
///
/// * "􀉅" You can display a larger view of the card
/// * "􀈎" You can edit an existing card
/// * "􀈑" You can delete a specific instance of a card.
/// 
struct MenuOverlayView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    @State var areYouSure: Bool = false
    @State var isEditActive: Bool = false
    @State var isCardActive: Bool = false
    @Binding var navigationPath: NavigationPath
    
    private let blankCardFront = UIImage(named: "frontImage")
    private var iPhone = false
    private var card: Card?
    private var greetingCard: GreetingCard?
    private var isEventType: ListView = .recipients
    
    init(card: Card?, greetingCard: GreetingCard?, isEventType: ListView, navigationPath: Binding<NavigationPath>) {
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
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            iPhone = true
        }
        self.card = card
        self.greetingCard = greetingCard
        self.isEventType = isEventType
        self._navigationPath = navigationPath
    }
    
    
    var body: some View {
        HStack {
            Spacer()
            NavigationLink {
                if isEventType != .greetingCard {
                    EditCardView(card: Bindable(card!), navigationPath: $navigationPath)
                }
            } label: {
                Image(systemName: "square.and.pencil")
                    .foregroundColor(.green)
                    .font(iPhone ? .caption : .title3)
            }
            NavigationLink {
                if isEventType != .greetingCard {
                    CardView(cardImage: card!.cardUIImage())
                        .aspectRatio(2/3, contentMode: .fit)
                } else {
                    CardView(cardImage: greetingCard!.cardUIImage())
                        .aspectRatio(2/3, contentMode: .fit)
                }
            } label: {
                Image(systemName: "doc.richtext")
                    .foregroundColor(.green)
                    .font(iPhone ? .caption : .title3)
            }
            Button(action: {
                areYouSure.toggle()
            }, label: {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .font(iPhone ? .caption : .title3)
            })
            .confirmationDialog("Are you sure", isPresented: $areYouSure, titleVisibility: .visible) {
                Button("Yes", role:.destructive) {
                    withAnimation {
                        if isEventType != .greetingCard {
                            print("Deleting Event \(String(describing: card?.eventType)) \(String(describing: card?.cardDate))")
                            deleteCard(card: card!)
                        } else {
                            print("Deleting Greeting Card \(String(describing: greetingCard?.eventType)) \(String(describing: greetingCard?.cardName))")
                            deleteGreetingCard(greetingCard: greetingCard!)
                        }
                    }
                }
                Button("No") {
                    withAnimation {
                        if isEventType != .greetingCard {
                            print("Cancelled delete of \(String(describing: card?.eventType)) \(String(describing: card?.cardDate))")
                        } else {
                            print("Cancelled delete of \(String(describing: greetingCard?.eventType)) \(String(describing: greetingCard?.cardName))")
                        }
                    }
                }
                .keyboardShortcut(.defaultAction)
            }
        }
    }
    
    private func deleteCard(card: Card) {
        let logger=Logger(subsystem: "com.theapapp.cardTracker", category: "MenuOverlayView.deleteCard")
        let taskContext = modelContext
        
        taskContext.delete(card)
        do {
            try taskContext.save()
        } catch {
            let nsError = error as NSError
            logger.log("Unresolved error \(nsError), \(nsError.userInfo)")
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func deleteGreetingCard(greetingCard: GreetingCard) {
        let logger=Logger(subsystem: "com.theapapp.cardTracker", category: "MenuOverlayView.deleteGreetingCard")
        let taskContext = modelContext
        
        taskContext.delete(greetingCard)
        do {
            try taskContext.save()
        } catch {
            let nsError = error as NSError
            logger.log("Unresolved error \(nsError), \(nsError.userInfo)")
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
