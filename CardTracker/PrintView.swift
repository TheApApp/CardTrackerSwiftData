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
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.systemGreen,
            .font: UIFont(name: "ArialRoundedMTBold", size: 35)!]
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.systemGreen,
            .font: UIFont(name: "ArialRoundedMTBold", size: 20)!]
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        
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
                        .frame(width: 130, height: 103)
                } else {
//                    Image(uiImage: (greetingCard?.cardUIImage())!)
                    Image(uiImage: UIImage(data: (greetingCard?.cardFront)!) ?? UIImage(named: "frontImage")!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaledToFit()
                        .frame(width: 130, height: 103)
                }
                HStack {
                    VStack {
                        switch isEventType {
                        case .events:
                            Text("\(card?.recipient?.fullName ?? "Unknown")")
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            Text("\(card!.cardDate, formatter: cardDateFormatter)")
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        case .recipients:
                            Text("\(card!.recipient?.fullName ?? "Unknown")")
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            Text("\(card!.cardDate, formatter: cardDateFormatter)")
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        case .greetingCard:
                            Text("\(String(describing: greetingCard!.cardName))")
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            Text("Used \(greetingCard?.cards?.count ?? 0) times")
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                    }
                }
            }
        }
        .padding()
        .scaledToFit()
        .frame(width: 143, height: 134)
        .mask(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 5)
    }
}

