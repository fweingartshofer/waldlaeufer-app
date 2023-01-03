//
//  HeatmapView.swift
//  waldlaeufer
//
//  Created by Andreas Wenzelhuemer on 29.12.22.
//
//

import SwiftUI
import MapKit

struct HeatmapView: View {

    @StateObject var manager = LocationManager()
    @ObservedObject private var viewModel = LocationDataViewModel()

    var body: some View {
        Map(
                coordinateRegion: $manager.region,
                showsUserLocation: true,
                userTrackingMode: .constant(.follow),
                annotationItems: viewModel.locationData.map { data -> MapLocation in
                    MapLocation(name: "", latitude: data.geoLocation.latitude, longitude: data.geoLocation.longitude)
                },
                annotationContent: { location in
                    MapPin(coordinate: location.coordinate, tint: .red)
                }
        )
                .onAppear {
                    let currentLocation = $manager.region.wrappedValue
                    viewModel.findInArea(
                            geoLocation: GeoLocation(
                                    latitude: currentLocation.center.latitude,
                                    longitude: currentLocation.center.longitude
                            ))
                }
    }
}

struct HeatmapView_Previews: PreviewProvider {
    static var previews: some View {
        HeatmapView()
    }
}
