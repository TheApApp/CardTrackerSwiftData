//
//  GreetingCardScreenView.swift
//  GreetingTracker
//
//  Created by Michael Rowe on 1/24/25.
//

import os
import SwiftData
import SwiftUI


enum GreetingCardActionType: Identifiable {
    case edit
    case display
    case delete
    
    var id: Self { self }
}

struct GreetingCardScreenView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var isIphone: IsIphone
    
    private var logger = Logger(subsystem: "com.theapa.CardTracker", category: "GreetingCardScreenView")
    
    private let blankCardFront = UIImage(named: "frontImage")
    private var greetingCard: GreetingCard?
    private var isVision = UIDevice.current.userInterfaceIdiom == .vision
    @Binding var navigationPath: NavigationPath
    @State private var areYouSure = false
    @State private var selectedAction: EventsActionType? = nil
    
    // MARK: formatting options
    var paddingValueOuter: CGFloat {
        isIphone.iPhone ? 5 : 10
    }
    
    var paddingValueInner: CGFloat {
        isIphone.iPhone ? 1 : isVision ? 1 : 5
    }
    
    var frameMinWidth: CGFloat {
        isIphone.iPhone ? 160 : isVision ? 160 : 320
    }
    
    var frameMaxWidth: CGFloat {
        isIphone.iPhone ? 160 : isVision ? 160 : 320
    }
    
    var fontInfo: Font {
        isIphone.iPhone ? .caption : isVision ? .system(size: 8) : .title3
    }
    
    init(greetingCard: GreetingCard?, navigationPath: Binding<NavigationPath>) {
        self.greetingCard = greetingCard
        self._navigationPath = navigationPath
    }
    
    // MARK: Body View
    var body: some View {
        ZStack {
            Button {
                selectedAction = .display
            } label: {
                ZStack {
                    AsyncImageView(imageData: greetingCard?.cardFront)
                    
                    VStack {
                        Spacer()
                        VStack {
                            VStack {
                                Text("\(greetingCard?.cardName ?? "Unknown")")
                                Text("\(greetingCard?.cardsCount() ?? 0) Cards Sent")
                                    .fixedSize()
                            }
                        }
                        .padding(2)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black.opacity(0.6))
                        )
                        .foregroundColor(.white)
                        .padding(paddingValueInner)
                        .font(fontInfo)
                        .foregroundColor(Color("AccentColor"))
                    }
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
                card: greetingCard,
                navigationPath: $navigationPath,
                deleteCard: deleteCard,
                logger: logger
            )
        }
        
    }
    
    
    // MARK: - Actions
    
    private func deleteCard(_ card: GreetingCard) {
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
        var card: GreetingCard
        
        var body: some View {
            EditGreetingCardView(greetingCard: card)
        }
    }
    
    struct DisplayViewWrapper: View {
        var card: GreetingCard
        
        var body: some View {
            CardView(
                cardImage: UIImage(data: (card.cardFront ?? UIImage(named: "frontImage")?.pngData())!)!,
                cardTitle: card.cardName,
                cardDate: nil
            )
        }
    }
    
    struct DeleteViewWrapper: View {
        @State private var areYouSure = true
        var card: GreetingCard
        let deleteCard: (GreetingCard) -> Void // Closure to call the delete function
        let logger: Logger // Pass the logger for logging
        
        var body: some View {
            ZStack {
                AsyncImageView(imageData: card.cardFront)
                VStack {
                    Text("Delete \(card.cardName)?")
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
                    }
                }
                Button("No", role: .cancel) {
                    logger.log("Deletion cancelled")
                }
            }
        }
    }
    
    
    struct ActionSheetContentView: View {
        var action: EventsActionType
        var card: GreetingCard?
        @Binding var navigationPath: NavigationPath
        let deleteCard: (GreetingCard) -> Void
        let logger: Logger
        
        var body: some View {
            if let card = card {
                switch action {
                case .edit:
                    EditViewWrapper(card: card)
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
    
    GreetingCardScreenView(greetingCard:
                            GreetingCard(cardName: "Cool Christmas Card", cardFront: nil, cardManufacturer: "MicroCards", cardURL: "https://michaelrowe01.com"), navigationPath: .constant(NavigationPath()))
    .environmentObject(IsIphone.init())
    .frame(width: 160, height: 160)
    
}
#Preview("iPad") {
    GreetingCardScreenView(greetingCard:
                            GreetingCard(cardName: "Cool Christmas Card", cardFront: nil, cardManufacturer: "MicroCards", cardURL: "https://michaelrowe01.com"), navigationPath: .constant(NavigationPath()))
    .environmentObject(IsIphone.init())
    .frame(width: 320, height: 320)
}
