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

    @State private var isSelected = false

    init(cardImage: UIImage) {
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
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(uiImage: cardImage)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .scaledToFit()
                    .frame(width: 175, height: 175)
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
        
        return CardView(cardImage: previewer.card.cardUIImage())
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
