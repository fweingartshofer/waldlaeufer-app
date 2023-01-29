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

    @StateObject private var viewModel = HeatmapViewModel()
    @State var selectedLocationData: LocationData? = nil
    @State var userTrackingMode: MapUserTrackingMode = .none

    @State private var timer: Timer?

    var body: some View {
        NavigationStack {
            ZStack {
                Map(
                        coordinateRegion: Binding(
                                get: { viewModel.region },
                                set: { newValue, _ in

                                    viewModel.region = newValue
                                    timer?.invalidate()

                                    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
                                        logger.log(level: .info, "\(Date()) assigning new value \(newValue)")
                                        viewModel.findInArea(geoLocation: GeoLocation(coordinates: newValue))
                                    })

                                }),
                        showsUserLocation: true,
                        userTrackingMode: $userTrackingMode,
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
                        .ignoresSafeArea(edges: .all)
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            viewModel.moveToCurrentLocation()
                        } label: {
                            Image(systemName: "scope")
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color.white)
                                    .background(Color.gray)
                                    .clipShape(Circle())
                        }
                                .buttonStyle(PlainButtonStyle())
                                .padding()
                    }
                    Spacer()
                    AddButtonView(currentRegion: $viewModel.region)
                            .padding()
                }
            }
        }
    }

    func getColor(_ locationData: LocationData) -> Color {
        switch (locationData.subjectiveWellbeing) {
        case .REALLY_BAD:
            return Color.red.opacity(0.6)
        case .BAD:
            return Color.orange.opacity(0.6)
        case .GOOD:
            return Color.green.opacity(0.4)
        case .REALLY_GOOD:
            return Color.green.opacity(0.7)
        }
    }
}

struct HeatmapView_Previews: PreviewProvider {
    static var previews: some View {
        HeatmapView()
    }
}
