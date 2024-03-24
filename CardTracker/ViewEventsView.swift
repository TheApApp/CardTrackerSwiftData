//
//  ViewEventsView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/11/23.
//

import MapKit
import os
import SwiftData
import SwiftUI

struct ViewEventsView: View {
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
    @State var PDFUrl: URL?
    @State var showShareSheet: Bool = false
    
    init(recipient: Recipient, navigationPath: Binding<NavigationPath>) {
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
        
        self.recipient = recipient
        let recipientID = recipient.persistentModelID // Note this is required to help in Macro Expansion
        _cards = Query(
            filter: #Predicate {$0.recipient?.persistentModelID == recipientID },
            sort: [
                SortDescriptor(\Card.cardDate, order: .reverse),
            ]
        )
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.gridLayout = [
                GridItem(.adaptive(minimum: 320), spacing: 20, alignment: .center)
            ]
        } else {
            iPhone = true
            self.gridLayout = [
                GridItem(.adaptive(minimum: 160), spacing: 10, alignment: .center)
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
                        ScreenView(card: card, greetingCard: nil, isEventType: .recipients, navigationPath: $navigationPath)
                    }
                    .padding()
                }
            }
            .navigationTitle("Cards Sent")
            .foregroundColor(.green)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                                    HStack {
                Button(action: {
                    navBarItemChosen = .newCard
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                })
//                ShareLink("Export PDF", item: render(viewsPerPage: 16))
//                    .foregroundColor(.green)
            }
            )
        }
        .sheet(item: $navBarItemChosen ) { item in
            switch item {
            case .newCard:
                NewCardView(recipient: recipient)
            }
        }
    }
    
    @MainActor func render(viewsPerPage: Int) -> URL {
        let cardsArray: [Card] = cards.map { $0 }
        let url = URL.documentsDirectory.appending(path: "\(recipient.fullName)-cards.pdf")
        var pageSize = CGRect(x: 0, y: 0, width: 612, height: 792)
        
        guard let pdfOutput = CGContext(url as CFURL, mediaBox: &pageSize, nil) else {
            return url
        }
        
        let numberOfPages = Int((cards.count + viewsPerPage - 1) / viewsPerPage)   // Round to number of pages
        let viewsPerRow = 4
        let rowsPerPage = 4
        let spacing = 10.0
        
        for pageIndex in 0..<numberOfPages {
            let startIndex = pageIndex * viewsPerPage
            let endIndex = min(startIndex + viewsPerPage, cardsArray.count)
            
            var currentX : Double = 0
            var currentY : Double = 0
            
            pdfOutput.beginPDFPage(nil)
            
            // Printer header - top 160 points of the page
            let renderTop = ImageRenderer(content: AddressView(recipient: recipient))
            renderTop.render { size, renderTop in
                // Go to Bottom Left of Page and then translate up to 160 points from the top
                pdfOutput.move(to: CGPoint(x: 0.0, y: 0.0))
                pdfOutput.translateBy(x: 0.0, y: 692)
                currentY += 692
                renderTop(pdfOutput)
            }
            pdfOutput.translateBy(x: spacing / 2, y: -160)
            
            for row in 0..<rowsPerPage {
                for col in 0..<viewsPerRow {
                    let index = startIndex + row * viewsPerRow + col
                    if index < endIndex, let card = cardsArray[safe: index] {
                        let renderBody = ImageRenderer(content: PrintView(card: card, greetingCard: nil, isEventType: .events))
                        renderBody.render { size, renderBody in
                            renderBody(pdfOutput)
                            pdfOutput.translateBy(x: size.width + 10, y: 0)
                            currentX += size.width + 10
                        }
                    }
                }
                pdfOutput.translateBy(x: -pageSize.width + 5, y: -144)
                currentY -= 153
                currentX = 0
            }
            
            // Print Footer - from bottom of page, up 40 points
            let renderBottom = ImageRenderer(content: FooterView(page: pageIndex + 1, pages: numberOfPages))
            pdfOutput.move(to: CGPoint(x: 0, y: 0))
            pdfOutput.translateBy(x: 0, y: 40)
            renderBottom.render { size, renderBottom in
                renderBottom(pdfOutput)
            }
            pdfOutput.endPDFPage()
        }
        pdfOutput.closePDF()
        return url
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
}
