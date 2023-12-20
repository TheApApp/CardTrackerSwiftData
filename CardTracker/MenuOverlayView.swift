//
//  MenuOverlayView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/11/23.
//

import os
import SwiftData
import SwiftUI

struct MenuOverlayView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    @State var areYouSure: Bool = false
    @State var isEditActive: Bool = false
    @State var isCardActive: Bool = false
    
    private let blankCardFront = UIImage(named: "frontImage")
    private var iPhone = false
    private var card: Card?
    private var greetingCard: GreetingCard?
    private var isEventType: ListView = .recipients
    
    init(card: Card?, greetingCard: GreetingCard?, isEventType: ListView) {
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
    }
    
    
    var body: some View {
        HStack {
            Spacer()
            NavigationLink {
                if isEventType != .greetingCard {
                    EditCardView(card: card!)
                }
            } label: {
                Image(systemName: "square.and.pencil")
                    .foregroundColor(.green)
                    .font(iPhone ? .caption : .title3)
            }
            NavigationLink {
//                CardView(cardImage: UIImage(data: (card?.cardFront?.cardFront)!) ?? UIImage(named: "frontImage")!, event: card?.eventType?.eventName ?? "Unknown", eventDate: card?.cardDate ?? Date())
                CardView(cardImage: UIImage(data: (card?.cardFront?.cardFront)!) ?? UIImage(named: "frontImage")!)
            } label: {
                Image(systemName: "doc.text.image")
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
                        print("Deleting Event \(String(describing: card?.eventType)) \(String(describing: card?.cardDate))")
                        deleteCard(card: card!)
                    }
                }
                Button("No") {
                    withAnimation {
                        print("Cancelled delete of \(String(describing: card?.eventType)) \(String(describing: card?.cardDate))")
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
