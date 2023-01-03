//
//  HeatmapView.swift
//  waldlaeufer
//
//  Created by Andreas Wenzelhuemer on 29.12.22.
//
//

import Logging
import SwiftUI
import MapKit
import FirebaseFirestore

struct HeatmapView: View {

    let logger = Logger(label: "HeatmapView")

    @StateObject var manager = LocationManager()
//    var coordinate: CLLocationCoordinate2D
    @State private var region = MKCoordinateRegion()
    @ObservedObject private var viewModel = LocationDataViewModel()

    var body: some View {
        Map(
                coordinateRegion: $region,
                showsUserLocation: true,
                userTrackingMode: .constant(.follow),
                annotationItems: viewModel.locationData.map { data -> MapLocation in
                    MapLocation(name: "", latitude: data.geoLocation.latitude, longitude: data.geoLocation.longitude)
                },
                annotationContent: { location in
                    MapPin(coordinate: location.coordinate, tint: .red)
                }
        )
                .onChange(of: manager) { newRegion in
                    logger.log(level: .error, "onChange: \(manager.region.center)")
                }
                .onAppear {
                    setRegion(manager.region.center)
                }
    }

    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        logger.log(level: .error, "setRegion: \(manager.region.center)")
        viewModel.findInArea(geoLocation: GeoLocation(coordinates: coordinate))
        region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    }
}

struct HeatmapView_Previews: PreviewProvider {
    static var previews: some View {
        HeatmapView()
    }
}
