//
//  CardView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/16/23.
//

import SwiftUI

/// CardView presents an image of a single Card, sized in a 175 frame.
struct CardView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme

    var cardImage: UIImage
    var cardTitle = ""

//    @State private var isSelected = false

    init(cardImage: UIImage, cardTitle: String) {
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
        self.cardTitle = cardTitle
    }

    var body: some View {
        GeometryReader { geo in
            VStack {
                Image(uiImage: cardImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaledToFit()
                    .frame(width: geo.size.width * 0.95, height: geo.size.height * 0.95)
                    .padding(2)
                    .mask(RoundedRectangle(cornerRadius: 25))

            }
            .padding(5)
            .font(.title)
            .foregroundColor(.primary)
            .navigationTitle("\(cardTitle)")
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return CardView(cardImage: previewer.card.cardUIImage(), cardTitle: "Title")
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
