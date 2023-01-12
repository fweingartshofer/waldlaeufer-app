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

    @StateObject private var viewModel = LocationDataViewModel()
    @State var selectedLocationData: LocationData? = nil
    @Binding var region: MKCoordinateRegion

    var body: some View {
        Map(
                coordinateRegion: Binding(
                        get: { region },
                        set: { newValue, _ in
                            logger.log(level: .info, "\(Date()) assigning new value \(newValue)")
                            region = newValue
                            viewModel.findInArea(geoLocation: GeoLocation(coordinates: newValue))
                        }),
                showsUserLocation: true,
                userTrackingMode: .constant(.none),
                annotationItems: viewModel.locationData) { (location: LocationData) in
            MapAnnotation(coordinate: location.geoLocation.asCLLocationCoordinate2D()) {
                Button {
                    selectedLocationData = location
                } label: {
                    Circle()
                            .fill(getColor(location))
                            .frame(width: 33, height: 33)
                }
            }
        }
                .sheet(item: $selectedLocationData) { locationData in
                    LocationDataDetailView(locationData: locationData)
                            .presentationDetents([.medium])
                }

    }

    func getColor(_ locationData: LocationData) -> Color {
        switch (locationData.subjectiveWellbeing) {
        case .REALLY_BAD:
            return Color.red.opacity(0.7)
        case .BAD:
            return Color.orange.opacity(0.6)
        case .GOOD:
            return Color.green.opacity(0.5)
        case .REALLY_GOOD:
            return Color.green.opacity(0.8)
        }
    }
}

struct HeatmapView_Previews: PreviewProvider {
    static var previews: some View {
        HeatmapView(region: .constant(MKCoordinateRegion()))
    }
}
