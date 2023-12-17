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
    private var card: Card
    var isEventType: Bool = false
    
    init(card: Card, isEventType: Bool) {
        self.card = card
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
                Image(uiImage: UIImage(data: card.cardFront) ?? UIImage(named: "frontImage")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: iPhone ? 120 : 225, height: iPhone ? 120 : 225)
                    .scaledToFit()
                    .padding(.top, iPhone ? 2: 5)
                HStack {
                    VStack {
                        if isEventType == true {
                            Text("\(card.recipient?.fullName ?? "Unknown")")
                                .foregroundColor(.green)
                        } else {
                            Text("\(String(describing: card.eventType?.eventName ?? "Unknown"))")
                                .foregroundColor(.green)
                        }
                        Spacer()
                        HStack {
                            Text("\(card.cardDate, formatter: cardDateFormatter)")
                                .fixedSize()
                                .foregroundColor(.green)
                            MenuOverlayView(card: card)
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
