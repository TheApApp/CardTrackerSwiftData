//
//  CardView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/16/23.
//

import SwiftUI

struct CardView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme

    var cardImage: UIImage
//    var event: String
//    var eventDate: Date?

    @State private var isSelected = false

    init(cardImage: UIImage) {
//        init(cardImage: UIImage, event: String, eventDate: Date? = nil) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.systemGreen,
            .font: UIFont(name: "ArialRoundedMTBold", size: 35)!
        ]
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.systemGreen,
            .font: UIFont(name: "ArialRoundedMTBold", size: 20)!
        ]

        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        self.cardImage = cardImage
//        self.event = event
//        self.eventDate = eventDate
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image( uiImage: cardImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(2)
                    .mask(RoundedRectangle(cornerRadius: 25))
                    .shadow(radius: isSelected ? 2 : 0 )
                    .onTapGesture {
                        isSelected.toggle()
                    }
                Spacer()
            }
            .padding(5)
            .font(.title)
            .foregroundColor(.primary)
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return CardView(cardImage: UIImage(data: (previewer.card.cardFront?.cardFront)!)!)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
