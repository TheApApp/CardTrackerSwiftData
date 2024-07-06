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
    @EnvironmentObject var isIphone: IsIphone
    
    @State var areYouSure: Bool = false
    @State var isEditActive: Bool = false
    @State var isCardActive: Bool = false
    @Binding var navigationPath: NavigationPath
    
    private var isVision = false
    
    private let blankCardFront = UIImage(named: "frontImage")
    private var card: Card?
    private var greetingCard: GreetingCard?
    private var isEventType: ListView = .recipients
    
    init(card: Card?, greetingCard: GreetingCard?, isEventType: ListView, navigationPath: Binding<NavigationPath>) {
        
        if UIDevice.current.userInterfaceIdiom == .vision {
            self.isVision = true
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
                } else {
                    if isEventType == .greetingCard {
                        EditGreetingCardView(greetingCard: greetingCard)
                    }
                }
            } label: {
                Image(systemName: "square.and.pencil")
                    .foregroundColor(.accentColor)
                    .font(isIphone.iPhone ? .caption : isVision ? .system(size: 8) : .title3)
            }
            NavigationLink {
                if isEventType != .greetingCard {
                    if let card = card,
                       let cardFrontData = card.cardFront?.cardFront,
                       let cardImage = UIImage(data: cardFrontData) ?? UIImage(named: "frontImage") {
                        CardView(cardImage: cardImage, cardTitle: "\(card.cardDate.formatted(date: .abbreviated, time: .omitted))")
                    } else {
                        let defaultImage = UIImage(named: "frontImage") ?? UIImage()
                        CardView(cardImage: defaultImage, cardTitle: "Unknown Date")
                    }
                } else {
                    if let greetingCard = greetingCard,
                       let cardFrontData = greetingCard.cardFront,
                       let cardImage = UIImage(data: cardFrontData) ?? UIImage(named: "frontImage") {
                        CardView(cardImage: cardImage, cardTitle: greetingCard.cardName)
                    } else {
                        let defaultImage = UIImage(named: "frontImage") ?? UIImage()
                        CardView(cardImage: defaultImage, cardTitle: "Missing EventType")
                    }
                }
            } label: {
                Image(systemName: "doc.richtext")
                    .foregroundColor(.accentColor)
                    .font(isIphone.iPhone ? .caption : isVision ? .system(size: 8) : .title3)
            }
            Button(action: {
                areYouSure.toggle()
            }, label: {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .font(isIphone.iPhone ? .caption : isVision ? .system(size: 8) : .title3)
            })
            .confirmationDialog("Are you sure", isPresented: $areYouSure, titleVisibility: .visible) {
                Button("Yes", role:.destructive) {
                    withAnimation {
                        if isEventType != .greetingCard {
                            deleteCard(card: card!)
                        } else {
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
            Spacer()
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
