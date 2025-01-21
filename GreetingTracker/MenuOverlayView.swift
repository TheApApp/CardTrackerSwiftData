import os
import SwiftData
import SwiftUI

import SwiftUI
import os

struct MenuOverlayView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var isIphone: IsIphone

    @State private var areYouSure: Bool = false
    @State private var destination: Destination? = nil
    @Binding var navigationPath: NavigationPath

    private var logger = Logger(subsystem: "com.theapa.CardTracker", category: "MenuOverlay")
    private var isVision = UIDevice.current.userInterfaceIdiom == .vision

    private let blankCardFront = UIImage(named: "frontImage")
    private var card: Card?
    private var greetingCard: GreetingCard?
    private var isEventType: ListView

    init(card: Card?, greetingCard: GreetingCard?, isEventType: ListView, navigationPath: Binding<NavigationPath>) {
        self.card = card
        self.greetingCard = greetingCard
        self.isEventType = isEventType
        self._navigationPath = navigationPath
    }

    var body: some View {
        VStack {
            Color.clear // Empty content to attach the context menu
        }
        .contextMenu {
            Button(action: {
                navigateToEditView()
            }) {
                Label("Edit", systemImage: "square.and.pencil")
            }

            Button(action: {
                navigateToDetailedView()
            }) {
                Label("Details", systemImage: "doc.richtext")
            }

            Button(role: .destructive, action: {
                areYouSure.toggle()
            }) {
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
        .navigationDestination(for: Destination.self) { destination in
            switch destination {
            case .editView:
                editView
            case .detailedView:
                detailedView
            }
        }
    }

    // MARK: - Navigation Logic

    private func navigateToEditView() {
        destination = .editView
    }

    private func navigateToDetailedView() {
        destination = .detailedView
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

    // MARK: - Destination Enum

    private enum Destination: Hashable {
        case editView
        case detailedView
    }
}
