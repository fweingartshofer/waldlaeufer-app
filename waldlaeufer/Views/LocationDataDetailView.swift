//
//  LocationDataDetailView.swift
//  waldlaeufer
//
//  Created by Andreas Wenzelhuemer on 03.01.23.
//
//

import SwiftUI
import MapKit

struct LocationDataDetailView: View {

    @State var locationData: LocationData
    @Environment(\.dismiss) private var dismiss

    @StateObject var viewModel = LocationDataDetailViewModel()

    var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .finished(let tags):
                List {
                    if tags.count > 0 {
                        DetailRowView(label: "Tags", content: tags.joined(separator: ", "))
                    }
                    if let radius = locationData.radius {
                        DetailRowView(label: "Radius", content: radius.description)
                    }
                    DetailRowView(label: "Wellbeing", content: locationData.subjectiveWellbeing.description)
                    if let db = locationData.db {
                        DetailRowView(label: "Decibel (dB)", content: String(format: "%.2f", db))
                    }
                }
                        .navigationBarTitle(Text("Details"), displayMode: .inline)
                        .navigationBarItems(
                                leading: Button(action: {
                                    let placemark = MKPlacemark(coordinate: locationData.geoLocation.asCLLocationCoordinate2D())
                                    let mapItem = MKMapItem(placemark: placemark)
                                    mapItem.name = "Custom Location"
                                    mapItem.openInMaps()
                                }) {
                                    Image(systemName: "map")
                                },
                                trailing: Button(action: {
                                    dismiss()
                                }) {
                                    Text("Close").bold()
                                })
            }
        }
                .onAppear {
                    viewModel.start(ld: locationData)

                }
    }
}

struct LocationDataDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDataDetailView(
                locationData: LocationData(id: nil,
                        timestamp: Date(),
                        subjectiveWellbeing: .GOOD,
                        geoLocation: GeoLocation(latitude: 0, longitude: 0),
                        db: nil,
                        radius: nil,
                        tags: [])
        )
    }
}
