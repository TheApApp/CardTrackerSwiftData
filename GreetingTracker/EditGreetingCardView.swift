//
//  EditGreetingCardView.swift
//  GreetingTracker
//
//  Created by Michael Rowe on 1/2/24.
//

import AVKit
import SwiftData
import SwiftUI

/// EdtiGreetingCardView allows for editing an existing Greeting Card.  You may change any value including replacing the image with a new value from your Photo Library, or via the camera
/// A view for creating or editing a greeting card, including setting its event, details, and image.

struct EditGreetingCardView: View {
    /// The shared model context used for saving and retrieving data.
    @Environment(\.modelContext) private var modelContext
    /// The dismiss environment value used to close the view.
    @Environment(\.dismiss) private var dismiss
    
    // A query that retrieves all `EventType` objects sorted by their `eventName` property.
    @Query(sort: \EventType.eventName) private var events: [EventType]
    
    /// The greeting card being edited, if it exists. If `nil`, the view creates a new card.
    var greetingCard: GreetingCard?
    /// The title displayed in the toolbar, depending on whether a new card is being created or an existing one is being edited.
    private var editorTitle: String { greetingCard == nil ? "Add Greeting Card" : "Edit Greeting Card" }
    
    /// The currently selected front image for the card, defaulting to a placeholder image.
    @State var frontImageSelected: Image? = Image("frontImage")
    /// The source type for selecting an image, either from the photo library or camera.
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    /// A flag to show the photo picker action sheet.
    @State var frontPhoto = false
    /// A flag to present the image picker for capturing or selecting a front image.
    @State var captureFrontImage = false
    
    /// An optionally passed eventType
    var eventTypePassed: EventType?
    
    /// The selected event type for the greeting card.
    @State private var eventType: EventType?
    /// The name of the card.
    @State private var cardName = ""
    /// The manufacturer of the card.
    @State private var cardManufacturer = ""
    /// The URL associated with the card.
    @State private var cardURL = ""
    /// The front image of the card as a `UIImage`.
    @State private var cardUIImage: UIImage?
    
    /// A flag indicating whether the camera is not authorized for use.
    @State private var cameraNotAuthorized = false
    /// A flag to present the camera interface.
    @State private var isCameraPresented = false
    /// A flag to track if a new event type is being added.
    @State private var newEvent = false
    
    @AppStorage("walkthrough") var walkthrough = 1
    
    init(eventTypePassed: EventType?) {
        if let eventTypePassed {
            _eventType = .init(initialValue: eventTypePassed)
        }
    }
    
    init(greetingCard: GreetingCard?) {
        self.greetingCard = greetingCard
    }
    
    var body: some View {
        Form {
            Section("Occasion") {
                Picker("Select Occasion", selection: $eventType) {
                    Text("Unknown Occasion")
                        .tag(Optional<EventType>.none) //basically added empty tag and it solve the case
                    
                    if events.isEmpty == false {
                        Divider()
                        
                        ForEach(events) { event in
                            Text(event.eventName)
                                .tag(Optional(event))
                        }
                    }
                }
                if eventType == nil {
                    NavigationLink(destination: EventTypeView()) {
                        Text("New Occasion")
                    }
                }
            }
            
            Section("Card details") {
                
                TextField("Description", text: $cardName)
                    .customTextField()
                TextField("Manufacturer", text: $cardManufacturer)
                    .customTextField()
                TextField("Website", text: $cardURL)
                    .customTextField()
                    .autocapitalization(.none)
            }
            .foregroundColor(.accentColor)
            
            Section("Card Image") {
                HStack(alignment: .center){
                    Spacer()
                    ZStack {
                        Image(uiImage: cardUIImage ?? UIImage(named: "frontImage")!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .shadow(radius: 10 )
                        Image(systemName: "camera.fill")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .shadow(radius: 10)
                            .frame(width: 200)
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
                                            self.captureFrontImage.toggle()
                                            self.sourceType = .photoLibrary }),
                                        ActionSheet.Button.cancel()
                                    ]
                                )
#endif
                            }
                            .sheet(isPresented: $captureFrontImage) {
                                ImagePicker(
                                    sourceType: sourceType,
                                    image: $frontImageSelected)
                                .interactiveDismissDisabled(true)
                            }
                        
                    }
                    .frame(width: 250, height: 250)
                    Spacer()
                }
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
        
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(editorTitle)
                    .font(Font.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(.accentColor)
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    withAnimation {
                        save()
                        dismiss()
                    }
                } label: {
                    Text("Save")
                }
                .disabled($cardUIImage.wrappedValue == nil)
            }
            
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    if walkthrough == 3 {
                        walkthrough += 1
                    }
                    dismiss()
                }
            }
        }
        
        .onAppear {
            if let greetingCard {
                cardName = greetingCard.cardName
                cardManufacturer = greetingCard.cardManufacturer
                cardURL = greetingCard.cardURL
                cardUIImage = UIImage(data: (greetingCard.cardFront)!) ?? UIImage(named: "frontImage")!
                eventType = greetingCard.eventType
            }
        }
        
        .onChange(of: frontImageSelected) { oldValue, newValue in
            cardUIImage = newValue?.asUIImage()
        }
#if os(macOS)
        .padding()
#endif
        Spacer()
    }
    
    @MainActor private func save() {
        if walkthrough == 3 {
            walkthrough += 1
        }
        ImageCompressor.compress(image: (frontImageSelected?.asUIImage())!, maxByte: 1_048_576) { image in
            guard image != nil else {
                print("Error compressing image")
                return
            }
            if let greetingCard {
                greetingCard.cardName = cardName
                greetingCard.cardFront = image?.pngData()
                greetingCard.cardManufacturer = cardManufacturer
                greetingCard.cardURL = cardURL
                greetingCard.eventType = eventType
                
            } else {
                let newGreetingCard = GreetingCard(cardName: cardName, cardFront: image?.pngData(), eventType: eventType, cardManufacturer: cardManufacturer, cardURL: cardURL)
                modelContext.insert(newGreetingCard)
            }
        }
    }
    
    @MainActor func openSettings() {
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

#Preview("Add Greeting Card") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: GreetingCard.self, configurations: config)
    let card: GreetingCard? = nil
    
    EditGreetingCardView(greetingCard: card)
        .modelContainer(container)
}

#Preview("Edit Greeting Card") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: GreetingCard.self, configurations: config)
    let card = GreetingCard(cardName: "CardName", cardFront: Data(), cardManufacturer: "ABB", cardURL: "cardSampleURL")
    
    return EditGreetingCardView(greetingCard: card)
        .modelContainer(container)
}
