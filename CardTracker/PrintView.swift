//
//  PrintView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/11/23.
//

import SwiftData
import SwiftUI

struct PrintView: View {
    let blankCardFront = UIImage(contentsOfFile: "frontImage")
    var card: Card?
    var greetingCard: GreetingCard?
    var isEventType: ListView = .recipients
    
    init(card: Card?, greetingCard: GreetingCard?, isEventType: ListView) {
        self.card = card
        self.greetingCard = greetingCard
        self.isEventType = isEventType
    }
    
    var body: some View {
        HStack {
            VStack {
                if isEventType != .greetingCard {
                    Image(uiImage: UIImage(data: (card?.cardFront?.cardFront)!) ?? UIImage(named: "frontImage")!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaledToFit()
                        .frame(width: 125, height: 115)
                } else {
                    Image(uiImage: UIImage(data: (greetingCard?.cardFront)!) ?? UIImage(named: "frontImage")!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaledToFit()
                        .frame(width: 125, height: 115)
                }
                HStack {
                    VStack {
                        switch isEventType {
                        case .events:
                            Text("\(card?.recipient?.fullName ?? "Unknown")")
                                .lineLimit(1)
                                .minimumScaleFactor(0.3)
                            Text("\(card!.cardDate, formatter: cardDateFormatter)")
                                .lineLimit(1)
                                .minimumScaleFactor(0.3)
                        case .recipients:
                            Text("\(card!.recipient?.fullName ?? "Unknown")")
                                .lineLimit(1)
                                .minimumScaleFactor(0.3)
                            Text("\(card!.cardDate, formatter: cardDateFormatter)")
                                .lineLimit(1)
                                .minimumScaleFactor(0.3)
                        case .greetingCard:
                            Text("\(String(describing: greetingCard!.cardName))")
                                .lineLimit(1)
                                .minimumScaleFactor(0.3)
                            Text("Used \(greetingCard?.cards?.count ?? 0) times")
                                .lineLimit(1)
                                .minimumScaleFactor(0.3)
                        }
                    }
                }
            }
        }
        .padding()
        .scaledToFit()
        .frame(width: 130, height: 139)
        .mask(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 5)
    }
}

#Preview {
    PrintView(card: nil, greetingCard: GreetingCard(cardName: "Happy Card", cardFront: UIImage(named: "frontImage")?.pngData(), cardManufacturer: "The ApAPp", cardURL: "https://michaelrowe01.com"), isEventType: .greetingCard)
}
