//
//  ScreenView.swift
//  GreetingTracker
//
//  Created by Michael Rowe on 12/16/23.
//

import SwiftData
import SwiftUI

struct ScreenView: View {
    @EnvironmentObject var isIphone: IsIphone
    
    private let blankCardFront = UIImage(named: "frontImage")
    private var card: Card?
    private var greetingCard: GreetingCard?
    private var isVision = UIDevice.current.userInterfaceIdiom == .vision
    private var isEventType: ListView
    @Binding var navigationPath: NavigationPath

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
                    
                    HStack {
                        VStack(alignment: .leading) {
                            MenuOverlayView(
                                card: isEventType != .greetingCard ? card : nil,
                                greetingCard: isEventType == .greetingCard ? greetingCard : nil,
                                isEventType: isEventType,
                                navigationPath: $navigationPath
                            )
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
