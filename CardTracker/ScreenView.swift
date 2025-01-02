//
//  ScreenView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/16/23.
//

import SwiftData
import SwiftUI

struct ScreenViewXXX: View {
    @EnvironmentObject var isIphone: IsIphone
    
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
        ZStack {
            if isEventType != .greetingCard {
                AsyncImageView(imageData: card!.cardFront?.cardFront)
            } else {
                AsyncImageView(imageData: greetingCard!.cardFront)
            }

            VStack {
//                HStack {
//                    Spacer()
//                    VStack(alignment: .leading) {
//                        switch isEventType {
//                        case .events:
//                            MenuOverlayView(card: card!, greetingCard: greetingCard, isEventType: .events, navigationPath: $navigationPath)
//                        case .recipients:
//                            MenuOverlayView(card: card!, greetingCard: greetingCard, isEventType: .recipients, navigationPath: $navigationPath)
//                        case .greetingCard:
//                            MenuOverlayView(card: nil, greetingCard: greetingCard, isEventType: .greetingCard, navigationPath: $navigationPath)
//                        }
//                    }
//                }
                
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
            }
            .foregroundColor(.white)
            .padding(isIphone.iPhone ? 1 : isVision ? 1 : 5)
            .font(isIphone.iPhone ? .caption : isVision ? .system(size: 8) : .title3)
            .foregroundColor(.accentColor)
            
        }
        
        .padding()
        //        .frame(minWidth: isIphone.iPhone ? 160 : isVision ? 400 : 320, maxWidth: .infinity,
        //               minHeight: isIphone.iPhone ? 160 : isVision ? 400 : 320, maxHeight: .infinity)
        .frame(minWidth: isIphone.iPhone ? 160 : 320, maxWidth: .infinity,
               minHeight: isIphone.iPhone ? 160 : 320, maxHeight: .infinity)
        .background(Color(UIColor.systemGroupedBackground))
        .mask(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 5)
        .padding(isIphone.iPhone ? 5: 10)
    }
}
