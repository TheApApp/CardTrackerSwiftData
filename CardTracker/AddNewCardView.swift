//
//  AddNewCardView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/11/23.
//

import os
import SwiftData
import SwiftUI

struct AddNewCardView: View {
    var recipient: Recipient
    @Query(sort: \EventType.eventName) private var events: [EventType]
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var zoomed = false
    
    enum CaptureCardView: Identifiable {
        case front
        var id: Int {
            hashValue
        }
    }
    
    @State var captureCardView: CaptureCardView?
    @State private var selectedEvent: EventType?
    @State private var cardDate = Date()
    @State var frontImageSelected: Image? = Image("frontImage")
    @State var shouldPresentCamera = false
    @State var frontPhoto = false
    @State var captureFrontImage = false
    
    init(recipient: Recipient) {
        self.recipient = recipient
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack {
                    HStack {
                        Text("Event")
                        Spacer()
                        Picker(selection: $selectedEvent, label: Text("")) {
                            ForEach(events) { event in
                                Text(event.eventName)
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
                            Image(systemName: "camera.fill")
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
            .navigationBarTitle("\(recipient.fullName)")
            .navigationBarItems(trailing:
                                    HStack {
                Button(action: {
                    saveCard()
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "square.and.arrow.down")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                })
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.down.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                })
            }
            )
        }
    }
    
    func saveCard() {
        let logger=Logger(subsystem: "com.theapapp.cardTracker", category: "AddNewCardView")
        logger.log("saving...")
        print("Selected Event = \(String(describing: selectedEvent))")
        ImageCompressor.compress(image: (frontImageSelected?.asUIImage())!, maxByte: maxBytes) { image in
            guard image != nil else {
                logger.log("Error compressing image")
                return
            }
            if selectedEvent != nil {
                let card = Card(cardDate: cardDate, eventName: selectedEvent!, cardFront: (image?.pngData())!, recipient: recipient)
                print("Selected Event = \(String(describing: selectedEvent))")
                modelContext.insert(card)
            }
            do {
                try modelContext.save()
            } catch let error as NSError {
                logger.log("Save error \(error), \(error.userInfo)")
            }
        }
    }
}
