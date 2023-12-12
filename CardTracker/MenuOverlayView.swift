//
//  MenuOverlayView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/11/23.
//

import os
import SwiftData
import SwiftUI

struct MenuOverlayView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    @State var areYouSure: Bool = false
    @State var isEditActive: Bool = false
    @State var isCardActive: Bool = false
    
    private let blankCardFront = UIImage(named: "frontImage")
    private var iPhone = false
    private var card: Card
    private var recipient: Recipient
    
    init(recipient: Recipient, card: Card) {
        if UIDevice.current.userInterfaceIdiom == .phone {
            iPhone = true
        }
        self.recipient = recipient
        self.card = card
    }
    
    
    var body: some View {
        HStack {
            Spacer()
            NavigationLink {
                
            } label: {
                Image(systemName: "square.and.pencil")
                    .foregroundColor(.green)
                    .font(iPhone ? .caption : .title3)
            }
            NavigationLink {
                
            } label: {
                Image(systemName: "doc.text.image")
                    .foregroundColor(.green)
                    .font(iPhone ? .caption : .title3)
            }
            Button(action: {
                areYouSure.toggle()
            }, label: {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .font(iPhone ? .caption : .title3)
            })
            .confirmationDialog("Are you sure", isPresented: $areYouSure, titleVisibility: .visible) {
                Button("Yes", role:.destructive) {
                    withAnimation {
                        print("Deleting Event \(String(describing: card.event)) \(card.cardDate)")
                        deleteCard(card: card)
                    }
                }
                Button("No") {
                    withAnimation {
                        print("Cancelled delete of \(String(describing: card.event)) \(card.cardDate)")
                    }
                }
                .keyboardShortcut(.defaultAction)
            }
        }
    }
    
    private func deleteCard(card: Card) {
        let logger=Logger(subsystem: "com.theapapp.cardTracker", category: "MenuOverlayView.deleteCard")
        let taskContext = modelContext

        taskContext.delete(card)
        do {
            try taskContext.save()
        } catch {
            let nsError = error as NSError
            logger.log("Unresolved error \(nsError), \(nsError.userInfo)")
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
