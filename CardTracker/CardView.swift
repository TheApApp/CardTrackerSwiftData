//
//  CardView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/16/23.
//

import SwiftUI

struct CardView: View {
    @Environment(\.presentationMode) var presentationMode
    var cardImage: UIImage
    var event: String
    var eventDate: Date

    @State private var zoomed = true

    init(cardImage: UIImage, event: String, eventDate: Date) {
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
        self.event = event
        self.eventDate = eventDate
    }

    static let eventDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image( uiImage: cardImage)
                    .resizable()
                    .aspectRatio(contentMode: zoomed ? .fit : .fill)
                    .padding(2)
                    .mask(RoundedRectangle(cornerRadius: 25))
                    .onTapGesture {
                        withAnimation {
                            zoomed.toggle()
                        }
                    }
                Spacer()
            }
            VStack(alignment: .center) {
                Text(event)
                Text("\(eventDate, formatter: Self.eventDateFormatter)")
            }
            .padding(5)
            .font(.title)
            .foregroundColor(.primary)
        }
    }
}

#Preview {
    CardView(cardImage: UIImage(imageLiteralResourceName: "frontImage"), event: "Dummy", eventDate: Date())
}
