//
//  MapView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/11/23.
//

import MapKit
import SwiftUI

struct MapView: View {
    struct Place: Identifiable {
        let id = UUID()
        let name: String
        var latitude: Double
        var longitude: Double
        var coordinate: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    @State private var position: MapCameraPosition
    @State private var region: MKCoordinateRegion
    var places = [
        Place(name: "", latitude: 0.0, longitude: 0.0)
    ]
    
    init(region: MKCoordinateRegion) {
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
        
        var region = region
        region.span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(0.005), longitudeDelta: CLLocationDegrees(0.005))
        self._region = State(initialValue: region)
        self._position = State(initialValue: MapCameraPosition.region(region))
        places[0].longitude = region.center.longitude
        places[0].latitude = region.center.latitude
    }
    
    var body: some View {
        Map(position: $position) {
            Annotation("\(places[0].name)", coordinate: places[0].coordinate) {
                Image(systemName: "house")
                    .padding(4)
                    .foregroundStyle(.white)
                    .background(Color.green)
                    .cornerRadius(4)
            }
        }
        .mapStyle(.standard(elevation: .realistic))
        .onMapCameraChange { context in
            region = context.region
        }
    }
}
