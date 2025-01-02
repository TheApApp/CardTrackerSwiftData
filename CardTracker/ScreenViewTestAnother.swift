import os
import SwiftData
import SwiftUI

struct ScreenView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var isIphone: IsIphone
    @State private var areYouSure: Bool = false
    
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
            NavigationLink(destination: editCardDestination()) {
                menuLabel(title: "Edit Card", systemImage: "square.and.pencil")
            }
            NavigationLink(destination: displayCardDestination()) {
                menuLabel(title: "Display Card", systemImage: "doc.richtext")
            }
            Button(action: { areYouSure.toggle() }) {
                menuLabel(title: "Remove Card", systemImage: "trash", color: .red)
            }
            .confirmationDialog("Are you sure", isPresented: $areYouSure, titleVisibility: .visible) {
                confirmationButtons()
            }
        } label: {
            cardPreview()
        }
    }
    
    @ViewBuilder
    private func editCardDestination() -> some View {
        if isEventType != .greetingCard, let card = card {
            EditCardView(card: Bindable(card), navigationPath: $navigationPath)
        } else if let greetingCard = greetingCard {
            EditGreetingCardView(greetingCard: greetingCard)
        } else {
            EmptyView() // Fallback if neither card nor greetingCard is valid
        }
    }
    
    @ViewBuilder
    private func displayCardDestination() -> some View {
        if isEventType != .greetingCard, let card = card {
            let cardImage = UIImage(data: card.cardFront?.cardFront ?? Data()) ?? blankCardFront!
            CardView(cardImage: cardImage, cardTitle: card.cardFront?.cardName ?? "No Card Name", cardDate: card.cardDate)
        } else if let greetingCard = greetingCard {
            let cardImage = UIImage(data: greetingCard.cardFront ?? Data()) ?? blankCardFront!
            CardView(cardImage: cardImage, cardTitle: greetingCard.cardName, cardDate: Date())
        } else {
            let defaultImage = blankCardFront!
            CardView(cardImage: defaultImage, cardTitle: "Missing EventType", cardDate: Date())
        }
    }

    private func menuLabel(title: String, systemImage: String, color: Color = .accentColor) -> some View {
        HStack {
            Text(title)
            Image(systemName: systemImage)
                .foregroundColor(color)
                .font(isIphone.iPhone ? .caption : isVision ? .system(size: 8) : .title3)
        }
    }

    private func confirmationButtons() -> some View {
        Group {
            Button("Yes", role: .destructive) {
                withAnimation {
                    if isEventType != .greetingCard, let card = card {
                        deleteCard(card: card)
                    } else if let greetingCard = greetingCard {
                        deleteGreetingCard(greetingCard: greetingCard)
                    }
                }
            }
            Button("No", role: .cancel) {}
        }
    }

    private func cardPreview() -> some View {
        ZStack {
            if isEventType != .greetingCard {
                AsyncImageView(imageData: card?.cardFront?.cardFront)
            } else {
                AsyncImageView(imageData: greetingCard?.cardFront)
            }
            VStack {
                Spacer()
                cardInfo()
            }
            .foregroundColor(.white)
            .padding(isIphone.iPhone ? 1 : isVision ? 1 : 5)
            .font(isIphone.iPhone ? .caption : isVision ? .system(size: 8) : .title3)
        }
        .padding()
        .frame(minWidth: isIphone.iPhone ? 160 : 320, maxWidth: .infinity,
               minHeight: isIphone.iPhone ? 160 : 320, maxHeight: .infinity)
        .background(Color(UIColor.systemGroupedBackground))
        .mask(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 5)
        .padding(isIphone.iPhone ? 5 : 10)
    }
    
    @ViewBuilder
    private func cardInfo() -> some View {
        switch isEventType {
        case .events:
            VStack {
                Text(card?.recipient?.fullName ?? "Unknown")
                Text(card?.cardDate ?? Date(), formatter: cardDateFormatter)
            }
            .padding(2)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.black.opacity(0.6)))
        case .recipients:
            VStack {
                Text(card?.eventType?.eventName ?? "Unknown")
                Text(card?.cardDate ?? Date(), formatter: cardDateFormatter)
            }
            .padding(2)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.black.opacity(0.6)))
        case .greetingCard:
            VStack {
                Text("\(greetingCard?.cardName ?? "") - Sent: \(greetingCard?.cardsCount() ?? 0)")
            }
            .padding(2)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.black.opacity(0.6)))
        }
    }

    private func deleteCard(card: Card) {
        withAnimation {
            modelContext.delete(card)
            saveContext()
        }
    }

    private func deleteGreetingCard(greetingCard: GreetingCard) {
        withAnimation {
            modelContext.delete(greetingCard)
            saveContext()
        }
    }

    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            let nsError = error as NSError
            Logger(subsystem: "com.theapp.cardTracker", category: "Error")
                .log("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

