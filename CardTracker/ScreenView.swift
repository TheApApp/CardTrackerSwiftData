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
    
    init(card: Card?, greetingCard: GreetingCard?, isEventType: ListView) {
        self.card = card
        self.greetingCard = greetingCard
        self.isEventType = isEventType
        
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
                    Image(uiImage: UIImage(data: (card!.cardFront?.cardFront)!) ?? UIImage(named: "frontImage")!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaledToFit()
                        .frame(width: iPhone ? 130 : 250, height: iPhone ? 103 : 250)
                } else {
                    Image(uiImage: UIImage(data: (greetingCard?.cardFront)!) ?? UIImage(named: "frontImage")!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaledToFit()
                        .frame(width: iPhone ? 130 : 250, height: iPhone ? 103 : 250)
                }
                HStack {
                    VStack {
                        switch isEventType {
                        case .events:
                            Text("\(String(describing: card?.eventType?.eventName ?? "Unknown"))")
                                .foregroundColor(.green)
                            HStack {
                                Text("\(card!.cardDate, formatter: cardDateFormatter)")
                                    .fixedSize()
                                    .foregroundColor(.green)
                                MenuOverlayView(card: card, greetingCard: greetingCard, isEventType: .events)
                            }
                        case .recipients:
                            Text("\(card?.recipient?.fullName ?? "Unknown")")
                                .foregroundColor(.green)
                            HStack {
                                Text("\(card!.cardDate, formatter: cardDateFormatter)")
                                    .fixedSize()
                                    .foregroundColor(.green)
                                MenuOverlayView(card: card, greetingCard: greetingCard, isEventType: .recipients)
                            }
                        case .greetingCard:
//                            Text("\(String(describing: greetingCard!.eventType?.eventName ?? "Unknown"))")
                            HStack {
                                Text("\(greetingCard?.cardName ?? "")")
                                    .fixedSize(horizontal: false, vertical: true)
                                    .foregroundColor(.green)
                                MenuOverlayView(card: card, greetingCard: greetingCard, isEventType: .greetingCard)
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
