//
//  WalkThroughtView.swift
//  Greet Keeper
//
//  Created by Michael Rowe1 on 12/29/24.
//

import SwiftData
import SwiftUI

struct WalkThroughtView: View {
    @AppStorage("walkthrough") var walkthrough = 1
    @AppStorage("totalViews") var totalViews = 5

    @EnvironmentObject var iPhone: IsIphone

    var title: String
    var description: String
    var bgColor: String
    var img: String
    
    @State private var showNewEventView = false
    @State private var showNewGreetingCardView = false
    @State private var showNewRecipientView = false
    @State private var showNewCardView = false

    static var recipientDescriptor: FetchDescriptor<Recipient> {
        var descriptor = FetchDescriptor<Recipient>(sortBy: [SortDescriptor(\.persistentModelID, order: .reverse)])
        descriptor.fetchLimit = 1
        return descriptor
    }
    
    @Query(WalkThroughtView.recipientDescriptor) var recipients: [Recipient]
    var recipient: Recipient? { recipients.first}
    @Binding var eventType: EventType?
    
    var body: some View {
        ZStack{
            VStack(spacing: 0){
                HStack {
                    Text("Welcome!")
                        .foregroundColor(Color.white)
                        .accessibilityLabel("Welcome!")
                        .fontWeight(.bold)
                    Spacer()
                    Button(
                        action:{
                            walkthrough = (totalViews + 1)
                        },
                        label: {
                            Text("Skip")
                                .foregroundColor(Color.white)
                        }
                    )
                }
                .padding()
                Spacer()
                VStack(alignment: .leading, spacing: 0){
                    Image(img)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: iPhone.iPhone ? 300 : 600, height: iPhone.iPhone ? 300 : 600)
                        .cornerRadius(30)
                        .padding(.bottom, 20)

                    Text(title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        .font(.title2)
                        .padding(.top)

                    Text(description)
                        .frame(maxWidth: iPhone.iPhone ? 300 : .infinity, alignment: .leading)
                        .padding(.top, 3.0)
                        .padding(.bottom, 10.0)
                        .fixedSize(horizontal: true, vertical: true)
                        .lineLimit(nil)
                        .foregroundColor(Color.white)

                    if walkthrough == 2 {
                        Button {
                            showNewEventView.toggle()
                        } label: {
                            Text("Create an occasion")
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                                .font(.title3)
                        }
                        .buttonStyle(.borderedProminent)
                    } else if walkthrough == 3 {
                        Button {
                            showNewGreetingCardView.toggle()
                        } label: {
                            Text("Create a card")
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                                .font(.title3)
                        }
                        .buttonStyle(.borderedProminent)
                    } else if walkthrough == 4 {
                        Button {
                            showNewRecipientView.toggle()
                        } label: {
                            Text("Create a recipient")
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                                .font(.title3)
                        }
                        .buttonStyle(.borderedProminent)
                    } else if walkthrough == 5 {
                        Button {
                            showNewCardView.toggle()
                        } label: {
                            Text("Send the recipient the card")
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                                .font(.title3)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                    Spacer(minLength: 0)
                        .padding(.bottom, 30)

                }
                .padding()
                .overlay(
                    HStack{
                        
                        if walkthrough == 1 {
                            ContainerRelativeShape()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 5)
                        } else {
                            ContainerRelativeShape()
                                .foregroundColor(.white.opacity(0.5))
                                .frame(width: 25, height: 5)
                        }
                        
                        if walkthrough == 2 {
                            ContainerRelativeShape()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 5)
                        } else {
                            ContainerRelativeShape()
                                .foregroundColor(.white.opacity(0.5))
                                .frame(width: 25, height: 5)
                        }
                        
                        if walkthrough == 3 {
                            ContainerRelativeShape()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 5)
                        } else {
                            ContainerRelativeShape()
                                .foregroundColor(.white.opacity(0.5))
                                .frame(width: 25, height: 5)
                        }
                        
                        if walkthrough == 4 {
                            ContainerRelativeShape()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 5)
                        } else {
                            ContainerRelativeShape()
                                .foregroundColor(.white.opacity(0.5))
                                .frame(width: 25, height: 5)
                        }
                        
                        if walkthrough == 5 {
                            ContainerRelativeShape()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 5)
                        } else {
                            ContainerRelativeShape()
                                .foregroundColor(.white.opacity(0.5))
                                .frame(width: 25, height: 5)
                        }
                        Spacer()
                        Button(
                            action:{
                                withAnimation(.easeOut) {
                                    if walkthrough <= totalViews || walkthrough == 2 {
                                        walkthrough += 1
                                    } else if walkthrough == totalViews {
                                        walkthrough = 1
                                    }
                                }
                            },
                            label: {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 35.0, weight: .semibold))
                                    .frame(width: 55, height: 55)
                                    .background(Color("BgNextBtn"))
                                    .clipShape(Circle())
                                    .padding(17)
                                    .overlay(
                                        ZStack{
                                            Circle()
                                                .stroke(Color.white.opacity(0.4), lineWidth: 2)
                                                .padding()
                                                .foregroundColor(Color.white)
                                        }
                                    )
                            }
                        )
                    }
                        .padding()
                    ,alignment: .bottomTrailing
                )
            }
        }

        .fullScreenCover(isPresented: $showNewEventView) {
            EventTypeView(eventType: eventType)
        }
        .fullScreenCover(isPresented: $showNewGreetingCardView) {
            EditGreetingCardView(eventTypePassed: eventType)
        }
        .fullScreenCover(isPresented: $showNewRecipientView) {
            RecipientView(recipientToEdit: recipient)
        }
        .fullScreenCover(isPresented: $showNewCardView) {
            NewCardView(recipient: recipient!, eventTypePassed: eventType)
        }
        //.background(Color(bgColor).ignoresSafeArea())
        .background(
            LinearGradient(colors: [
                Color(bgColor),Color("BgNextBtn")]
                           ,startPoint: .top, endPoint: .bottom)
        )
    }
}

#Preview {
    @Previewable @State var eventType: EventType? = EventType(eventName: "Birthday")
    
    WalkThroughtView(title: "WalkThrough", description: "This will show a lot of information", bgColor: "AccentColor", img:"Welcome_one", eventType: $eventType)
        .environmentObject(IsIphone())
}
