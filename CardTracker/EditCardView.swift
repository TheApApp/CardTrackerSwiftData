//
//  EditCardView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/10/23.
//

import os
import SwiftData
import SwiftUI

struct EditCardView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    @Query(sort: \EventType.eventName) private var events: [EventType]

    var card: Card
    var defaultImage = UIImage(named: "frontImage")

    @State private var cardFrontImage: Image?
    @State var frontImageSelected: Image? 
    @State private var eventName: String
    @State private var cardDate: Date
    @State private var selectedEvent: EventType?
    @State var frontPhoto = false
    @State var captureFrontImage = false
    @State var shouldPresentCamera = false

    init(card: Card) {
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
        self._cardDate = State(initialValue: card.cardDate)
        self._eventName = State(initialValue: card.event?.eventName ?? "")
        self._selectedEvent = State(initialValue: card.event)
        
    }

    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    Text("Event")
                    Spacer()
                    Picker(selection: $selectedEvent, label: Text("")) {
                        ForEach(events) { event in
                            Text(event.eventName)
                                .tag(Optional(event))
                        }
                    }
                    .frame(width: geo.size.width * 0.55, height: geo.size.height * 0.25)
                }
                .padding([.leading, .trailing], 10)
                DatePicker(
                    "Event Date",
                    selection: $cardDate,
                    displayedComponents: [.date])
                .padding([.leading, .trailing, .bottom], 10)
                HStack {
                    ZStack {
                        frontImageSelected?
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .shadow(radius: 10 )
                        VStack {
                            Image(systemName: "camera.fill")
                            Text("Front")
                        }
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .shadow(radius: 10)
                        .frame(width: geo.size.width * 0.45)
                        .onTapGesture { self.frontPhoto = true }
                        .actionSheet(isPresented: $frontPhoto) { () -> ActionSheet in
                            ActionSheet(
                                title: Text("Choose mode"),
                                message: Text("Select one."),
                                buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                                    self.captureFrontImage.toggle()
                                    self.shouldPresentCamera = true
                                }),
                                          ActionSheet.Button.default(Text("Photo Library"), action: {
                                              self.captureFrontImage.toggle()
                                              self.shouldPresentCamera = false
                                          }),
                                          ActionSheet.Button.cancel()])
                        }
                        .sheet(isPresented: $captureFrontImage) {
                            ImagePicker(
                                sourceType: self.shouldPresentCamera ? .camera : .photoLibrary,
                                image: $frontImageSelected,
                                isPresented: self.$captureFrontImage)
                        }
                    }
                }
                Spacer()
            }
        }
        .padding([.leading, .trailing], 10)
        .navigationBarTitle(
            "\(card.recipient?.fullName ?? "Missing Name")",
                            displayMode: .inline
        )
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Button(action: {
                    saveCard()
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "square.and.arrow.down")
                        .font(.title2)
                        .foregroundColor(.green)
                })
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.down.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                })
            }
        }
    }

    func saveCard() {
        let logger=Logger(subsystem: "com.theapapp.cardTracker", category: "EditCardView.saveCard")
        logger.log("saving...")
        print("Selected Event = \(String(describing: selectedEvent?.eventName))")
        ImageCompressor.compress(image: (frontImageSelected?.asUIImage())!, maxByte: maxBytes) { image in
            guard image != nil else {
                logger.log("Error compressing image")
                return
            }
            do {
                try modelContext.save()
            } catch let error as NSError {
                logger.log("Save error \(error), \(error.userInfo)")
            }
        }
    }
}

struct EditAnEvent_Previews: PreviewProvider {
    static var previews: some View {
        EditCardView(card: Card(cardDate: Date(), eventName: EventType(eventName: "Dummy Event"), cardFront: (UIImage(named: "frontImage")?.pngData())!, recipient: Recipient(addressLine1: "Line 1", addressLine2: "Line 2", city: "New York", state: "NY", zip: "01234", country: "USA", firstName: "First Name", lastName: "Last Name")))
    }
}
