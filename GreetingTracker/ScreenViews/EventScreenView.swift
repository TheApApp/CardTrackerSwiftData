//
//  EventScreenView.swift
//  GreetingTracker
//
//  Created by Michael Rowe on 1/24/25.
//

import os
import SwiftData
import SwiftUI


enum EventsActionType: Identifiable {
    case edit
    case display
    case delete
    
    var id: Self { self }
}

struct EventScreenView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var isIphone: IsIphone
    
    private var logger = Logger(subsystem: "com.theapa.CardTracker", category: "EventScreenView")
    
    private let blankCardFront = UIImage(named: "frontImage")
    private var card: Card?
    private var isVision = UIDevice.current.userInterfaceIdiom == .vision
    @Binding var navigationPath: NavigationPath
    @State private var areYouSure = false
    @State private var selectedAction: EventsActionType? = nil
    
    // MARK: formatting options
    var paddingValueOuter: CGFloat {
        isIphone.iPhone ? 5 : 10
    }
    
    var paddingValueInner: CGFloat {
        isIphone.iPhone ? 1 : 5
    }
    
    var frameMinWidth: CGFloat {
        isIphone.iPhone ? 160 : 320
    }
    
    var frameMaxWidth: CGFloat {
        isIphone.iPhone ? 160 : 320
    }
    
    var fontInfo: Font {
        isIphone.iPhone ? .caption : .title3
    }
    
    init(card: Card?, navigationPath: Binding<NavigationPath>) {
        self.card = card
        self._navigationPath = navigationPath
    }
    
    // MARK: Body View
    var body: some View {
        
        Button {
            selectedAction = .display
        } label: {
            ZStack {
                AsyncImageView(imageData: card?.cardFront?.cardFront)
                
                VStack {
                    Spacer()
                    VStack {
                        VStack {
                            Text("\(card?.recipient?.fullName ?? "Unknown")")
                            Text("\(card?.cardDate ?? Date(), formatter: cardDateFormatter)")
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding(2)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black.opacity(0.6))
                            .frame(maxWidth: .infinity)
                    )
                    .foregroundColor(.white)
                    .padding(paddingValueInner)
                    .font(fontInfo)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding()
        .frame(
            minWidth: frameMinWidth,
            maxWidth: frameMaxWidth,
            minHeight: frameMinWidth,
            maxHeight: frameMaxWidth
        )
        .background(Color("SlideColor"))
        .mask(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 5)
        .padding(paddingValueOuter)
        .contextMenu {
            Button(action: {
                selectedAction = .edit
            }) {
                Label("Edit", systemImage: "square.and.pencil")
            }
            
            Button(role: .destructive) {
                selectedAction = .delete
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        
        .sheet(item: $selectedAction) { action in
            ActionSheetContentView(
                action: action,
                card: card,
                navigationPath: $navigationPath,
                deleteCard: deleteCard,
                logger: logger
            )
        }
        
    }
    
    
    // MARK: - Actions
    
    private func deleteCard(_ card: Card) {
        modelContext.delete(card)
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
    
    struct EditViewWrapper: View {
        var card: Card
        @Binding var navigationPath: NavigationPath
        
        var body: some View {
            EditCardView(card: Bindable(card), navigationPath: $navigationPath)
        }
    }
    
    struct DisplayViewWrapper: View {
        var card: Card
        
        var body: some View {
            CardView(
                cardImage: UIImage(data: (card.cardFront?.cardFront ?? UIImage(named: "frontImage")?.pngData())!)!,
                cardTitle: card.eventType?.eventName ?? "No Title",
                cardDate: card.cardDate
            )
        }
    }
    
    struct DeleteViewWrapper: View {
        @Environment(\.dismiss) private var dismiss
        @State private var areYouSure = true
        var card: Card
        let deleteCard: (Card) -> Void // Closure to call the delete function
        let logger: Logger // Pass the logger for logging
        
        var body: some View {
            ZStack {
                AsyncImageView(imageData: card.cardFront?.cardFront)
                VStack {
                    Text("Delete \(card.eventType?.eventName ?? "No Title")")
                    Text("Are you sure?")
                }
                .padding(2)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.black.opacity(0.6))
                )
                .foregroundColor(.white)
                
            }
            .confirmationDialog("Are you sure?", isPresented: $areYouSure) {
                Button("Yes", role: .destructive) {
                    withAnimation {
                        deleteCard(card)
                        dismiss()
                    }
                }
                Button("No", role: .cancel) {
                    logger.log("Deletion cancelled")
                    dismiss()
                }
            }
        }
    }
    
    
    struct ActionSheetContentView: View {
        var action: EventsActionType
        var card: Card?
        @Binding var navigationPath: NavigationPath
        let deleteCard: (Card) -> Void
        let logger: Logger
        
        var body: some View {
            if let card = card {
                switch action {
                case .edit:
                    EditViewWrapper(card: card, navigationPath: $navigationPath)
                case .display:
                    DisplayViewWrapper(card: card)
                case .delete:
                    DeleteViewWrapper(card: card, deleteCard: deleteCard, logger: logger)
                }
            } else {
                ErrorView(message: "No card available.")
            }
        }
    }
    
    
    
    struct ErrorView: View {
        let message: String
        
        var body: some View {
            VStack {
                Text("Error")
                    .font(.headline)
                    .foregroundColor(.red)
                Text(message)
                    .font(.subheadline)
            }
            .padding()
        }
    }
}

#Preview("iPhone") {
    
    EventScreenView(card:
                        Card(cardDate: Date(), eventType: EventType(eventName: "Christmas"), cardFront: GreetingCard(cardName: "Cool Christmas Card", cardFront: nil, cardManufacturer: "MicroCards", cardURL: "https://michaelrowe01.com"), recipient: Recipient(addressLine1: "123 North Street", addressLine2: "Apt 123", city: "Anytown", state: "NC", zip: "22712", country: "USA", firstName: "Michael", lastName: "Rowe", category: .home)), navigationPath: .constant(NavigationPath()))
    .environmentObject(IsIphone.init())
    .frame(width: 160, height: 160)
    
}
#Preview("iPad") {
    EventScreenView(card:
                        Card(cardDate: Date(), eventType: EventType(eventName: "Christmas"), cardFront: GreetingCard(cardName: "Cool Christmas Card", cardFront: nil, cardManufacturer: "MicroCards", cardURL: "https://michaelrowe01.com"), recipient: Recipient(addressLine1: "123 North Street", addressLine2: "Apt 123", city: "Anytown", state: "NC", zip: "22712", country: "USA", firstName: "Michael", lastName: "Rowe", category: .home)), navigationPath: .constant(NavigationPath()))
    .environmentObject(IsIphone.init())
    .frame(width: 320, height: 320)
}
