//
//  ScreenView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/16/23.
//

import os
import SwiftData
import SwiftUI

struct ScreenView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var isIphone: IsIphone
    @State var areYouSure: Bool = false
    
    private let blankCardFront = UIImage(named: "frontImage")
    private var card: Card?
    private var greetingCard: GreetingCard?
    private var isVision = false
    var isEventType: ListView = .recipients
    @Binding var navigationPath: NavigationPath
    
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
        Menu {
            NavigationLink {
                if isEventType != .greetingCard {
                    EditCardView(card: Bindable(card!), navigationPath: $navigationPath)
                } else {
                    EditGreetingCardView(greetingCard: greetingCard)
                }
            } label: {
                HStack {
                    Text("Edit Card")
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.accentColor)
                        .font(isIphone.iPhone ? .caption : isVision ? .system(size: 8) : .title3)
                }
            }
            NavigationLink {
                if isEventType != .greetingCard {
                    if let card = card,
                       let cardFrontData = card.cardFront?.cardFront,
                       let cardImage = UIImage(data: cardFrontData) ?? UIImage(named: "frontImage") {
                        CardView(cardImage: cardImage, cardTitle: "\(card.cardFront?.cardName ?? "No Card Name")", cardDate: card.cardDate)
                    } else {
                        let defaultImage = UIImage(named: "frontImage") ?? UIImage()
                        CardView(cardImage: defaultImage, cardTitle: "Unknown Date", cardDate: Date())
                    }
                } else {
                    if let greetingCard = greetingCard,
                       let cardFrontData = greetingCard.cardFront,
                       let cardImage = UIImage(data: cardFrontData) ?? UIImage(named: "frontImage") {
                        CardView(cardImage: cardImage, cardTitle: greetingCard.cardName, cardDate: Date())
                    } else {
                        let defaultImage = UIImage(named: "frontImage") ?? UIImage()
                        CardView(cardImage: defaultImage, cardTitle: "Missing EventType", cardDate: Date())
                    }
                }
            } label: {
                HStack{
                    Text("Display Card")
                    Image(systemName: "doc.richtext")
                        .foregroundColor(.accentColor)
                        .font(isIphone.iPhone ? .caption : isVision ? .system(size: 8) : .title3)
                }
            }
            Button(action: {
                areYouSure.toggle()
            }, label: {
                HStack {
                    Text("Remove Card")
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .font(isIphone.iPhone ? .caption : isVision ? .system(size: 8) : .title3)
                }
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
        } label: {
            ZStack {
                if isEventType != .greetingCard {
                    AsyncImageView(imageData: card!.cardFront?.cardFront)
                } else {
                    AsyncImageView(imageData: greetingCard!.cardFront)
                }
                
                VStack {
                    Spacer()
                    switch isEventType {
                    case .events:
                        VStack {
                            Text("\(card?.recipient?.fullName ?? "Unknown")")
                            Text("\(card?.cardDate ?? Date(), formatter: cardDateFormatter)")
                                .fixedSize()
                        }
                        .padding(2)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black.opacity(0.6))
                        )
                    case .recipients:
                        VStack {
                            Text("\(card?.eventType?.eventName ?? "Unknown")")
                            Text("\(card?.cardDate ?? Date(), formatter: cardDateFormatter)")
                                .fixedSize()
                        }
                        .padding(2)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black.opacity(0.6))
                        )
                    case .greetingCard:
                        VStack {
                            Text("\(greetingCard?.cardName ?? "") - Sent: \(greetingCard?.cardsCount() ?? 0)")
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(2)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black.opacity(0.6))
                        )
                    }
                    
                }
                .foregroundColor(.white)
                .padding(isIphone.iPhone ? 1 : isVision ? 1 : 5)
                .font(isIphone.iPhone ? .caption : isVision ? .system(size: 8) : .title3)
                .foregroundColor(.accentColor)
                
            }
            
            .padding()
            .frame(minWidth: isIphone.iPhone ? 160 : 320, maxWidth: .infinity,
                   minHeight: isIphone.iPhone ? 160 : 320, maxHeight: .infinity)
            .background(Color(UIColor.systemGroupedBackground))
            .mask(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 5)
            .padding(isIphone.iPhone ? 5: 10)
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
