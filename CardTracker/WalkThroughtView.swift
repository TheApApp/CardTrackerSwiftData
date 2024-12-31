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
    
//    @Binding var navigationPath: NavigationPath
    
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
    
//    static var eventTypeDescriptor: FetchDescriptor<EventType> {
//        var descriptor = FetchDescriptor<EventType>(sortBy: [SortDescriptor(\.persistentModelID, order: .reverse)])
//        descriptor.fetchLimit = 1
//        return descriptor
//    }
    
//    @Query(WalkThroughtView.eventTypeDescriptor) var eventTypes: [EventType]
    @State private var eventType: EventType? = nil
    
    var body: some View {
        ZStack{
            VStack{
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
                }.padding()
                Spacer()
                VStack(alignment: .leading){
                    Image(img)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(30)
                        .padding()
                    
                    Text(title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        .font(.title)
                        .padding(.top)
                    
                    Text(description)
                        .padding(.top, 5.0)
                        .foregroundColor(Color.white)
                    
                    if walkthrough == 2 {
                        Button {
                            showNewEventView.toggle()
                        } label: {
                            Text("New Event")
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                                .font(.title)
                        }
                        .buttonStyle(.borderedProminent)
                    } else if walkthrough == 3 {
                        Button {
                            showNewGreetingCardView.toggle()
                        } label: {
                            Text("Create the card")
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                                .font(.title)
                        }
                        .buttonStyle(.borderedProminent)
                    } else if walkthrough == 4 {
                        Button {
                            showNewRecipientView.toggle()
                        } label: {
                            Text("Create the recipient")
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                                .font(.title)
                        }
                        .buttonStyle(.borderedProminent)
                    } else if walkthrough == 5 {
                        Button {
                            showNewCardView.toggle()
                        } label: {
                            Text("Add card to the recipient")
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                                .font(.title)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                    Spacer(minLength: 0)
                    
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
        .sheet(isPresented: $showNewEventView) {
            EventTypeView(eventType: eventType)
        }
        .sheet(isPresented: $showNewGreetingCardView) {
            EditGreetingCardView(eventTypePassed: eventType)
        }
        .sheet(isPresented: $showNewRecipientView) {
            RecipientView()
        }
        .sheet(isPresented: $showNewCardView) {
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
    WalkThroughtView(title: "WalkThrough", description: "This will show a lot of information", bgColor: "AccentColor", img:"Welcome_todo")
}
