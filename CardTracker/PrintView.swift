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
    var card: Card
    
    init(event: Card) {
        self.card = event
    }
    
    var body: some View {
        HStack {
            VStack {
                Image(uiImage: UIImage(data: card.cardFront) ?? UIImage(named: "frontImage")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaledToFit()
                    .frame(width: 130, height: 103)
                HStack {
                    VStack {
//                        Text("\(card.event?.eventName)")
                        Text("\(card.cardDate, formatter: cardDateFormatter)")
                    }
                    .font(.caption)
                }
            }
        }
        .padding()
        .frame(width: 143, height: 134)
        .mask(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 5)
    }
}

