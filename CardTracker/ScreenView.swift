//
//  ScreenView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/16/23.
//

import SwiftData
import SwiftUI

struct ScreenView: View {
    private let blankCardFront = UIImage(named: "frontImage")
    private var iPhone = false
    private var card: Card?
    private var greetingCard: GreetingCard?
    var isEventType: ListView = .recipients
    @Binding var navigationPath: NavigationPath
    
    init(card: Card?, greetingCard: GreetingCard?, isEventType: ListView, navigationPath: Binding<NavigationPath>) {
        self.card = card
        self.greetingCard = greetingCard
        self.isEventType = isEventType
        self._navigationPath = navigationPath
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            iPhone = false
        } else {
            iPhone = true
        }
    }
    
    var body: some View {
        HStack {
            VStack {
                if isEventType != .greetingCard {
                    AsyncImageView(imageData: card!.cardFront?.cardFront)
                } else {
                    AsyncImageView(imageData: greetingCard!.cardFront)
                }
                HStack {
                    VStack {
                        switch isEventType {
                        case .events:
                            Text("\(card?.recipient?.fullName ?? "Unknown")")
                                .foregroundColor(.green)
                            HStack {
                                Text("\(card?.cardDate ?? Date(), formatter: cardDateFormatter)")
                                    .fixedSize()
                                    .foregroundColor(.green)
                                MenuOverlayView(card: card!, greetingCard: greetingCard, isEventType: .events, navigationPath: $navigationPath)
                            }
                        case .recipients:
                            Text("\(card?.eventType?.eventName ?? "Unknown")")
                                .foregroundColor(.green)
                            HStack {
                                Text("\(card?.cardDate ?? Date(), formatter: cardDateFormatter)")
                                    .fixedSize()
                                    .foregroundColor(.green)
                                MenuOverlayView(card: card!, greetingCard: greetingCard, isEventType: .recipients, navigationPath: $navigationPath)
                            }
                        case .greetingCard:
                            HStack {
                                Text("\(greetingCard?.cardName ?? "") - Sent: \(greetingCard?.cardsCount() ?? 0)")
                                    .fixedSize(horizontal: false, vertical: true)
                                    .foregroundColor(.green)
                                MenuOverlayView(card: nil, greetingCard: greetingCard, isEventType: .greetingCard, navigationPath: $navigationPath)
                            }
                        }

                    }
                    .padding(iPhone ? 1 : 5)
                    .font(iPhone ? .caption : .title3)
                    .foregroundColor(.primary)
                }
            }
        }
        .padding()
        .frame(minWidth: iPhone ? 160 : 320, maxWidth: .infinity,
               minHeight: iPhone ? 160 : 320, maxHeight: .infinity)
        .background(Color(UIColor.systemGroupedBackground))
        .mask(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 5)
        .padding(iPhone ? 5: 10)
    }
}
