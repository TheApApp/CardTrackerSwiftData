//
//  NewPhotoView.swift
//  GreetingTracker
//
//  Created by Michael Rowe on 12/18/23.
//

import AVKit
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
    @State var frontPhoto = false
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var captureFrontImage: Bool = false
    
    @State private var cameraNotAuthorized = false
    @State private var isCameraPresented = false
    @State private var newEvent = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Details") {
                    HStack {
                        Text("Select Type")
                            .foregroundColor(Color("AccentColor"))
                            .font(.headline)
                        
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
                    }
                    NavigationLink("Add New Event", destination:EventTypeView())
                    
                    TextField("Description", text: $cardName)
                        .customTextField()
                    TextField("Manufacturer", text: $cardManufacturer)
                        .customTextField()
                    TextField("Website", text: $cardURLString)
                        .customTextField()
                }
                .foregroundColor(Color("AccentColor"))
                
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
                                #if !os(visionOS)
                                ActionSheet(
                                    title: Text("Choose mode"),
                                    message: Text("Select one."),
                                    buttons: [
                                        ActionSheet.Button.default(Text("Camera"), action: {
                                        checkCameraAuthorization()
                                        self.captureFrontImage.toggle()
                                        self.sourceType = .camera
                                    }),
                                        
                                        ActionSheet.Button.default(Text("Photo Library"), action: {
                                              self.captureFrontImage.toggle()
                                              self.sourceType = .photoLibrary
                                    }),
                                        
                                        ActionSheet.Button.cancel()
                                    ]
                                )
                                #else
                                ActionSheet(
                                    title: Text("Choose mode"),
                                    message: Text("Select one."),
                                    buttons: [
                                        ActionSheet.Button.default(Text("Photo Library"), action: {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                self.captureFrontImage = true
                                            }
                                              self.sourceType = .photoLibrary
                                    }),
                                        ActionSheet.Button.cancel()
                                    ]
                                )

                                #endif
                            }
                            .fullScreenCover(isPresented: $captureFrontImage) {
                                #if !os(visionOS)
                                ImagePicker(
                                    sourceType: sourceType,
                                    image: $frontImageSelected)
                                #else
                                ImagePicker(
                                    image: $frontImageSelected)
                                #endif
                            }
                    }
                    .frame(width: 350, height: 350)
                }
            }
            .alert(isPresented: $cameraNotAuthorized) {
                Alert(
                    title: Text("Unable to access the Camera"),
                    message: Text("To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app."),
                    primaryButton: .default(Text("Settings")) {
                        openSettings()
                    }
                    ,
                    secondaryButton: .cancel()
                )
            }

            .fullScreenCover(isPresented: $newEvent) {
                EventTypeView()
            }
            
            .padding([.leading, .trailing], 10)
            .navigationBarItems(trailing:
                                    HStack {
                Button(action: {
                    saveGreetingCard()
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "square.and.arrow.down")
                })
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.down.circle.fill")
                })
            }
            )
        }
        .foregroundColor(.accentColor)
    }
    
    @MainActor func saveGreetingCard() {
        ImageCompressor.compress(image: (frontImageSelected?.asUIImage())!, maxByte: 1_048_576) { image in
            guard image != nil else {
                print("Error compressing image")
                return
            }
            if selectedEvent != nil {
                                                 
                let greetingCard = GreetingCard(cardName: cardName, cardFront: (image?.pngData())!, eventType: selectedEvent, cardManufacturer: cardManufacturer, cardURL: cardURLString)
                modelContext.insert(greetingCard)
            }
            do {
                try modelContext.save()
            } catch let error as NSError {
                print("error \(error.localizedDescription)")
            }
        }
    }
    
    func openSettings() {
        #if os(macOS)
            SettingsLink {
                Text("Settings")
            }
        #else
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { _ in })
        }
        #endif
    }
    
    func checkCameraAuthorization() {
        var checkCamera: Bool
        checkCamera = AVCaptureDevice.authorizationStatus(for: .video) == .authorized
        
        if checkCamera == true {
            cameraNotAuthorized = false
        } else {
            cameraNotAuthorized = true
        }
    }
}

#Preview {
    NewGreetingCardView()
}
