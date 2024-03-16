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
    @Environment(\.modelContext) var modelContext
    @Bindable private var greetingCard: GreetingCard
    @Binding var navigationPath: NavigationPath
    @State var frontImageSelected: Image? = Image("frontImage")
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var frontPhoto = false
    @State var captureFrontImage = false
    
    @Query(sort: [
        SortDescriptor(\EventType.eventName)
    ]) var events: [EventType]
    
    init(greetingCard: Bindable<GreetingCard>, navigationPath: Binding<NavigationPath>) {
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
        
        self._greetingCard = greetingCard
        self._navigationPath = navigationPath
    }
    
    var body: some View {
        let _ = Self._printChanges()
        Form {
            Section {
                Picker("Select type", selection: $greetingCard.eventType) {
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
                TextField("Description", text: $greetingCard.cardName)
                    .customTextField()
                TextField("Manufacturer", text: $greetingCard.cardManufacturer)
                    .customTextField()
                TextField("Website", text: $greetingCard.cardURL)
                    .customTextField()
            }
            
            Section("Card Image") {
                ZStack {
                    Image(uiImage: greetingCard.cardUIImage())
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
                                buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                                    self.captureFrontImage.toggle()
                                    self.sourceType = .camera
                                }),
                                          ActionSheet.Button.default(Text("Photo Library"), action: {
                                              self.captureFrontImage.toggle()
                                              self.sourceType = .photoLibrary
                                          }),
                                          ActionSheet.Button.cancel()])
                        }
                        .sheet(isPresented: $captureFrontImage) {
                            ImagePicker(
                                sourceType: sourceType,
                                image: $frontImageSelected)
                        }
                }
                .frame(width: 230, height: 230)
            }
        }
        .navigationTitle(greetingCard.cardName)
    }
}

#Preview {
     let config = ModelConfiguration(isStoredInMemoryOnly: true)
     let container = try! ModelContainer(for: GreetingCard.self, configurations: config)
     @Bindable var card = GreetingCard(cardName: "CardName", cardFront: Data(), cardManufacturer: "ABB", cardURL: "cardSampleURL")
    
    return EditGreetingCardView(greetingCard: $card, navigationPath: .constant(NavigationPath()))
         .modelContainer(container)
}
