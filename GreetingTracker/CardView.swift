//
//  CardView.swift
//  GreetingTracker
//
//  Created by Michael Rowe on 12/16/23.
//

import os
import SwiftUI

/// CardView presents an image of a single Card, sized in a 95% frame.
///
struct CardView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    private var logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.example.CardTracker", category: "CardView")
    var cardImage: UIImage
    var cardTitle: String?
    var cardDate: Date?
    
    init(cardImage: UIImage, cardTitle: String? = "", cardDate: Date? = Date()) {
        self.cardImage = cardImage
        self.cardTitle = cardTitle
        self.cardDate = cardDate
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    Image(uiImage: cardImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaledToFit()
                        .frame(width: geo.size.width * 0.95, height: geo.size.height * 0.95)
                        .padding(5)
                        .mask(RoundedRectangle(cornerRadius: 25))
                    
                    VStack(spacing: 4) {
                        Spacer()
                        VStack {
                            Text(cardTitle ?? "No Title")
                            
                            if let cardDate = cardDate {
                                Text("\(cardDate, formatter: cardDateFormatter)")
                            }
                        }
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black.opacity(0.6))
                        )
                        .foregroundColor(.white)
                    }
                    .padding(.bottom, 10)
                    
                }
                .padding(5)
                .font(.title)
                .foregroundColor(.primary)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("OK", role: .cancel) {
                            dismiss()
                        }
                        .foregroundColor(Color("AccentColor"))
                    }
                }
            }
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return CardView(cardImage: UIImage(data: (previewer.card.cardFront?.cardFront)!) ?? UIImage(named: "frontImage")!, cardTitle: "Title", cardDate: Date())
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
