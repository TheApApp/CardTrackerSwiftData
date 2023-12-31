//
//  NewPhotoView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/18/23.
//

import os
import SwiftData
import SwiftUI

/// NewGreetingCardView allows for capturing new Greeting Cards into the Image gallery.  Images can be captured in one of two ways, importing from the user's Photo library or via the camera on their device.
struct NewGreetingCardView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    @Query(sort: \EventType.eventName) private var events: [EventType]
    
    @State private var selectedEvent: EventType?
    @State private var cardName: String = ""
    @State private var cardManufacturer: String = ""
    @State private var cardURLString: String = ""
    @State var frontImageSelected: Image? = Image("frontImage")
    @State var shouldPresentCamera = false
    @State var frontPhoto = false
    @State var captureFrontImage = false
    
    init() {
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
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Card Information") {
                    Picker("Select type", selection: $selectedEvent) {
                        Text("Unknown Event")
                            .tag(Optional<EventType>.none) //basically added empty tag and it solve the case
                        
                        if events.isEmpty == false {
                            Divider()
                            
                            ForEach(events) { event in
                                Text(event.eventName)
                                    .tag(Optional(event))
                            }
                        }
                    }
                    TextField("Description", text: $cardName)
                        .customTextField()
                    TextField("Manufacturer", text: $cardManufacturer)
                        .customTextField()
                    TextField("Website", text: $cardURLString)
                        .customTextField()
                }
                Section("Card Image") {
                    ZStack {
                        frontImageSelected?
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .shadow(radius: 10 )
                        Image(systemName: "camera.fill")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .shadow(radius: 10)
                            .frame(width: 150)
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
                    .frame(width: 300, height: 300)
                }
            }
            .padding([.leading, .trailing], 10)
            .navigationBarItems(trailing:
                                    HStack {
                Button(action: {
                    saveGreetingCard()
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "square.and.arrow.down")
                        .font(.largeTitle)
                        .foregroundColor(.accentColor)
                })
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.down.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.accentColor)
                })
            }
            )
        }
        .foregroundColor(.accentColor)
    }
    
    func saveGreetingCard() {
        let logger=Logger(subsystem: "com.theapapp.cardTracker", category: "NewGreetingCardView")
        logger.log("saving...")
        print("Selected Event = \(String(describing: selectedEvent?.eventName))")
        ImageCompressor.compress(image: (frontImageSelected?.asUIImage())!, maxByte: maxBytes) { image in
            guard image != nil else {
                logger.log("Error compressing image")
                return
            }
            if selectedEvent != nil {
                let greetingCard = GreetingCard(cardName: cardName, cardFront: (image?.pngData())!, eventType: selectedEvent, cardManufacturer: cardManufacturer, cardURL: URL(string: cardURLString))
                print("Selected Event = \(String(describing: selectedEvent))")
                modelContext.insert(greetingCard)
            }
            do {
                try modelContext.save()
            } catch let error as NSError {
                logger.log("Save error \(error), \(error.userInfo)")
            }
        }
    }
}

#Preview {
    NewGreetingCardView()
}
