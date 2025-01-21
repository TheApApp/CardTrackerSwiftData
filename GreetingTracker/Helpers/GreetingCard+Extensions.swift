//
//  GreetingCard+Extensions.swift
//  Greeting Tracker
//
//  Created by Michael Rowe1 on 1/9/25.
//

import Foundation
import SwiftUI

extension GreetingCard {
    static var mockData: [GreetingCard] {
        [
            GreetingCard(cardName: "Card one", cardFront: nil, cardManufacturer: "The ApApp", cardURL: "https://michaelrowe01.com"),
            GreetingCard(cardName: "Card two", cardFront: nil, cardManufacturer: "The ApApp", cardURL: "https://michaelrowe01.com"),
            GreetingCard(cardName: "Card three", cardFront: nil, cardManufacturer: "The ApApp", cardURL: "https://michaelrowe01.com"),
            GreetingCard(cardName: "Card four", cardFront: nil, cardManufacturer: "The ApApp", cardURL: "https://michaelrowe01.com"),
        ]
    }
}

#Preview {
    List(GreetingCard.mockData, id: \.cardName) { greetingCard in
        VStack {
            HStack {
                Text(greetingCard.cardName)
                Spacer()
            }
            HStack {
                Image(uiImage: UIImage(data: (greetingCard.cardFront)!) ?? UIImage(named: "frontImage")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                Spacer()
            }
            HStack {
                Text(greetingCard.cardManufacturer)
                Spacer()
            }
            HStack {
                Text(greetingCard.cardURL)
                Spacer()
            }
        }
    }
}
