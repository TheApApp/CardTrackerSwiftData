//
//  ScreenView.swift
//  GreetingTracker
//
//  Created by Michael Rowe on 12/16/23.
//

import os
import SwiftData
import SwiftUI

enum NavigationDestination: Identifiable, Hashable {
    case editCard(Card)
    case editGreetingCard(GreetingCard)
    case detailsCard(Card)
    case detailsGreetingCard(GreetingCard)
    // Add other cases if needed
    
    var id: String {
        switch self {
        case .editGreetingCard(let greetingCard):
            return "edit-\(greetingCard.id)"
        case .detailsGreetingCard(let greetingCard):
            return "details-\(greetingCard.id)"
        case .editCard(let card):
            return "edit-\(card.id)"
        case .detailsCard(let card):
            return "edit-\(card.id)"
        }
    }
}

struct ScreenView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var isIphone: IsIphone
    
    private var logger = Logger(subsystem: "com.theapa.CardTracker", category: "ScreenView")

    private let blankCardFront = UIImage(named: "frontImage")
    private var card: Card?
    private var greetingCard: GreetingCard?
    private var isVision = UIDevice.current.userInterfaceIdiom == .vision
    private var isEventType: ListView
    @Binding var navigationPath: NavigationPath
    @State private var areYouSure = false

    private var cardImage: Data? {
        if isEventType != .greetingCard {
            return card?.cardFront?.cardFront as Data?
        } else {
            return greetingCard?.cardFront as Data?
        }
    }

    private var mainText: String {
        switch isEventType {
        case .events:
            return "\(card?.recipient?.fullName ?? "Unknown")"
        case .recipients:
            return "\(card?.eventType?.eventName ?? "Unknown")"
        case .greetingCard:
            return "\(greetingCard?.cardName ?? "") - Sent: \(greetingCard?.cardsCount() ?? 0)"
        }
    }

    private var subText: String {
        switch isEventType {
        case .events, .recipients:
            if let cardDate = card?.cardDate {
                return cardDateFormatter.string(from: cardDate)
            } else {
                return cardDateFormatter.string(from: Date())
            }
        case .greetingCard:
            return ""
        }
    }

    init(card: Card?, greetingCard: GreetingCard?, isEventType: ListView, navigationPath: Binding<NavigationPath>) {
        self.card = card
        self.greetingCard = greetingCard
        self.isEventType = isEventType
        self._navigationPath = navigationPath
    }

    var body: some View {
        ZStack {
            AsyncImageView(imageData: cardImage)

            VStack {
                Spacer()
                VStack {
                    VStack {
                        Text(mainText)
                        if !subText.isEmpty {
                            Text(subText)
                                .fixedSize()
                        }
                    }
                }
                .padding(2)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.black.opacity(0.6))
                )
                .foregroundColor(.white)
                .padding(isIphone.iPhone ? 1 : isVision ? 1 : 5)
                .font(isIphone.iPhone ? .caption : isVision ? .system(size: 8) : .title3)
                .foregroundColor(.accentColor)
            }
        }
        .padding()
        .frame(
            minWidth: isIphone.iPhone ? 160 : isVision ? 160 : 320,
            maxWidth: .infinity,
            minHeight: isIphone.iPhone ? 160 : isVision ? 160 : 320,
            maxHeight: 320
        )
        .background(Color("SlideColor"))
        .mask(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 5)
        .padding(isIphone.iPhone ? 5 : 10)
        .contextMenu {
            // Context Menu Options
            if let card = card {
                Button(action: {
                    navigationPath.append(NavigationDestination.editCard(card))
                }) {
                    Label("Edit", systemImage: "square.and.pencil")
                }

                Button(action: {
                    navigationPath.append(NavigationDestination.detailsCard(card))
                }) {
                    Label("Details", systemImage: "doc.richtext")
                }
            }
            
            if let greetingCard = greetingCard {
                Button(action: {
                    navigationPath.append(NavigationDestination.editGreetingCard(greetingCard))
                }) {
                    Label("Edit", systemImage: "square.and.pencil")
                }

                Button(action: {
                    navigationPath.append(NavigationDestination.detailsGreetingCard(greetingCard))
                }) {
                    Label("Details", systemImage: "doc.richtext")
                }
            }

            Button(role: .destructive) {
                areYouSure.toggle()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .confirmationDialog("Are you sure?", isPresented: $areYouSure) {
            Button("Yes", role: .destructive) {
                withAnimation { delete() }
            }
            Button("No", role: .cancel) {
                logger.log("Deletion cancelled")
            }
        }
    }
    
    // MARK: - Helper Views

    private var editView: some View {
        Group {
            if isEventType != .greetingCard {
                if let card = card {
                    EditCardView(card: Bindable(card), navigationPath: $navigationPath)
                } else {
                    Text("Card is missing")
                }
            } else {
                if let greetingCard = greetingCard {
                    EditGreetingCardView(greetingCard: greetingCard)
                } else {
                    Text("Greeting card is missing")
                }
            }
        }
    }

    private var detailedView: some View {
        Group {
            if let viewData = cardOrGreetingCardData {
                CardView(cardImage: viewData.image, cardTitle: viewData.title, cardDate: viewData.date)
            } else {
                let defaultImage = UIImage(named: "frontImage") ?? UIImage()
                CardView(cardImage: defaultImage, cardTitle: "Missing Title", cardDate: Date())
            }
        }
    }

    // MARK: - Helper Properties

    private var cardOrGreetingCardData: (image: UIImage, title: String, date: Date)? {
        if isEventType != .greetingCard, let card = card {
            let image = UIImage(data: card.cardFront?.cardFront ?? blankCardFront?.pngData() ?? Data()) ?? blankCardFront ?? UIImage()
            let title = card.cardFront?.cardName ?? "No Card Name"
            let date = card.cardDate
            return (image, title, date)
        } else if let greetingCard = greetingCard, let data = greetingCard.cardFront, let image = UIImage(data: data) {
            return (image, greetingCard.cardName, Date())
        }
        return nil
    }
    
    // MARK: - Actions

    private func delete() {
        if isEventType != .greetingCard {
            if let card = card { deleteCard(card) }
        } else {
            if let greetingCard = greetingCard { deleteGreetingCard(greetingCard) }
        }
    }

    private func deleteCard(_ card: Card) {
        modelContext.delete(card)
        saveContext()
    }

    private func deleteGreetingCard(_ greetingCard: GreetingCard) {
        modelContext.delete(greetingCard)
        saveContext()
    }

    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            let nsError = error as NSError
            logger.error("Unresolved error: \(nsError), \(nsError.userInfo)")
        }
    }
}

#Preview {
    
    ScreenView(card: Card(cardDate: Date(), eventType: EventType(eventName: "Christmas"), cardFront: GreetingCard(cardName: "Cool Christmas Card", cardFront: nil, cardManufacturer: "MicroCards", cardURL: "https://michaelrowe01.com"), recipient: Recipient(addressLine1: "123 North Street", addressLine2: "Apt 123", city: "Anytown", state: "NC", zip: "22712", country: "USA", firstName: "Michael", lastName: "Rowe", category: .home)), greetingCard: nil, isEventType: .recipients, navigationPath: .constant(NavigationPath()))
        .environmentObject(IsIphone.init())
        .frame(width: 160, height: 160)
    
    ScreenView(card: Card(cardDate: Date(), eventType: EventType(eventName: "Christmas"), cardFront: GreetingCard(cardName: "Cool Christmas Card", cardFront: nil, cardManufacturer: "MicroCards", cardURL: "https://michaelrowe01.com"), recipient: Recipient(addressLine1: "123 North Street", addressLine2: "Apt 123", city: "Anytown", state: "NC", zip: "22712", country: "USA", firstName: "Michael", lastName: "Rowe", category: .home)), greetingCard: nil, isEventType: .recipients, navigationPath: .constant(NavigationPath()))
        .environmentObject(IsIphone.init())
        .frame(width: 320, height: 320)
}
