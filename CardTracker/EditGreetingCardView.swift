//
//  EditGreetingCardView.swift
//  CardTracker
//
//  Created by Michael Rowe on 1/2/24.
//

import SwiftData
import SwiftUI

/// EdtiGreetingCardView allows for editing an existing Greeting Card.  You may change any value including replacing the image with a new value from your Photo Library, or via the camera
struct EditGreetingCardView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var greetingCard: GreetingCard?
    
    private var editorTitle: String {
        greetingCard == nil ? "Add Greeting Card" : "Edit Greeting Card"
    }
    
    @State var frontImageSelected: Image? = Image("frontImage")
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var frontPhoto = false
    @State var captureFrontImage = false
    
    @State private var eventType: EventType?
    @State private var cardName = ""
    @State private var cardManufacturer = ""
    @State private var cardURL = ""
    @State private var cardUIImage: UIImage?
    
    @Query(sort: [
        SortDescriptor(\EventType.eventName)
    ]) var events: [EventType]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Select type", selection: $eventType) {
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
                
                Section("Details") {
                    TextField("Description", text: $cardName)
                        .customTextField()
                    TextField("Manufacturer", text: $cardManufacturer)
                        .customTextField()
                    TextField("Website", text: $cardURL)
                        .customTextField()
                }
                
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
                                    ActionSheet(
                                        title: Text("Choose mode"),
                                        message: Text("Select one."),
                                        buttons: [
                                            ActionSheet.Button.default(Text("Camera"), action: {
                                                self.captureFrontImage.toggle()
                                                self.sourceType = .camera }),
                                            ActionSheet.Button.default(Text("Photo Library"), action: {
                                                self.captureFrontImage.toggle()
                                                self.sourceType = .photoLibrary }),
                                            ActionSheet.Button.cancel()
                                        ]
                                    )
                                }
                                .sheet(isPresented: $captureFrontImage) {
                                    ImagePicker(
                                        sourceType: sourceType,
                                        image: $frontImageSelected)
                                }
                            
                        }
                        .frame(width: 230, height: 230)
                        Spacer()
                    }
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(editorTitle)
                        .font(Font.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(.accentColor)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        withAnimation {
                            save()
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                    }
                    .disabled($cardUIImage.wrappedValue == nil)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }

            .onAppear {
                if let greetingCard {
                    cardName = greetingCard.cardName
                    cardManufacturer = greetingCard.cardManufacturer
                    cardURL = greetingCard.cardURL
                    cardUIImage = greetingCard.cardUIImage()
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
    }
    
    private func save() {
        if let greetingCard {
            greetingCard.cardName = cardName
            greetingCard.cardFront = cardUIImage?.pngData()
            greetingCard.cardManufacturer = cardManufacturer
            greetingCard.cardURL = cardURL
            greetingCard.eventType = eventType
            
        } else {
            let newGreetingCard = GreetingCard(cardName: cardName, cardFront: cardUIImage?.pngData(), eventType: eventType, cardManufacturer: cardManufacturer, cardURL: cardURL)
            modelContext.insert(newGreetingCard)
        }
    }
}

#Preview("Add Greeting Card") {
     let config = ModelConfiguration(isStoredInMemoryOnly: true)
     let container = try! ModelContainer(for: GreetingCard.self, configurations: config)
     let card: GreetingCard? = nil
    
    return EditGreetingCardView(greetingCard: card)
         .modelContainer(container)
}

#Preview("Edit Greeting Card") {
     let config = ModelConfiguration(isStoredInMemoryOnly: true)
     let container = try! ModelContainer(for: GreetingCard.self, configurations: config)
     let card = GreetingCard(cardName: "CardName", cardFront: Data(), cardManufacturer: "ABB", cardURL: "cardSampleURL")
    
    return EditGreetingCardView(greetingCard: card)
         .modelContainer(container)
}
