//
//  ViewRecipientDetailsView.swift
//  GreetingTracker
//
//  Created by Michael Rowe1 on 1/21/25.
//


import MapKit
import os
import SwiftData
import SwiftUI

struct ViewRecipientDetailsView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    @Query(sort: [SortDescriptor(\Card.cardDate, order: .reverse)]) private var cards: [Card]
    
    private let blankCardFront = UIImage(named: "frontImage")
    private var gridLayout: [GridItem]
    private var iPhone = false
    private var recipient: Recipient
    
    @Binding var navigationPath: NavigationPath
    
    @State private var actionSheetPresented = false
    @State private var navBarItemChosen: NavBarItemChosen?
    @State private var region: MKCoordinateRegion?
    
    
    // MARK: PDF Properties
    @State private var PDFUrl: URL?
    @State private var showShareSheet: Bool = false
    @State private var isLoading: Bool = false
    
    init(recipient: Recipient, navigationPath: Binding<NavigationPath>) {
        print("DEBUG ViewRecipientDetailsView: recipient : \(recipient.fullName)")
        self.recipient = recipient
        let recipientID = recipient.persistentModelID // Note this is required to help in Macro Expansion
        _cards = Query(
            filter: #Predicate {$0.recipient?.persistentModelID == recipientID },
            sort: [
                SortDescriptor(\Card.cardDate, order: .reverse),
            ]
        )
        if UIDevice.current.userInterfaceIdiom == .phone {
            iPhone = true
            self.gridLayout = [
                GridItem(.adaptive(minimum: 160), spacing: 10, alignment: .center)
            ]
        } else if UIDevice.current.userInterfaceIdiom == .vision {
            self.gridLayout = [
                GridItem(.adaptive(minimum: 320), spacing: 20, alignment: .leading)
            ]
        } else {
            self.gridLayout = [
                GridItem(.adaptive(minimum: 320), spacing: 20, alignment: .center)
            ]
        }
        self._navigationPath = navigationPath
    }
    
    var body: some View {
        VStack {
            HStack {
                if let region = region {
                    MapView(region: region)
                        .frame(width: iPhone ? 120 : 200, height: 150)
                        .mask(RoundedRectangle(cornerRadius: 25))
                        .padding([.top, .leading], 15 )
                    AddressView(recipient: recipient)
                        .scaledToFit()
                        .frame(width: 250, height: 150)
                }
                Spacer()
                    .onAppear {
                        // swiftlint:disable:next line_length
                        let addressString = String("\(recipient.addressLine1) \(recipient.city) \(recipient.state) \(recipient.zip) \(recipient.country)")
                        getLocation(from: addressString) { coordinates in
                            if let coordinates = coordinates {
                                self.region = MKCoordinateRegion(
                                    center: coordinates,
                                    span: MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008))
                            }
                        }
                    }
            }
            ScrollView {
                LazyVGrid(columns: gridLayout, alignment: .center, spacing: 5) {
                    ForEach(cards) { card in
                        ReceipientScreenView(card: card, navigationPath: $navigationPath)
                    }
                }
                .padding()
            }
            
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("\(recipient.fullName)")
                        .foregroundColor(Color("AccentColor"))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        navBarItemChosen = .newCard
                    }, label: {
                        Image(systemName: "plus")
                            .foregroundColor(Color("AccentColor"))
                    })
                }
                ToolbarItem(placement:.navigationBarTrailing) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Button(action: generatePDF) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
            }
            .sheet(item: $navBarItemChosen ) { item in
                switch item {
                case .newCard:
                    NewCardView(recipient: recipient)
                        .interactiveDismissDisabled(true)
                }
            }
            .sheet(isPresented: $showShareSheet, content: {
                if let PDFUrl = PDFUrl {
                    ShareSheet(activityItems: [PDFUrl])
                        .interactiveDismissDisabled(true)
                }
            })
        }
    }
    
    func getLocation(from address: String, completion: @escaping (_ location: CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, _) in
            guard let placemarks = placemarks,
                  let location = placemarks.first?.location?.coordinate else {
                completion(nil)
                return
            }
            completion(location)
        }
    }
    
    private func generatePDF() {
        isLoading = true
        Task {
            let pdfGenerator = GeneratePDF(title: "\(recipient.fullName)", cards: cards, greetingCards: nil, cardArray: true)
            let pdfUrl = await pdfGenerator.render(viewsPerPage: 16)
            PDFUrl = pdfUrl
            isLoading = false
            showShareSheet = true
        }
    }
}
