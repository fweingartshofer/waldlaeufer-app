//
//  LocationDataDetailView.swift
//  waldlaeufer
//
//  Created by Andreas Wenzelhuemer on 03.01.23.
//
//

import SwiftUI

struct LocationDataDetailView: View {

    @State var locationData: LocationData
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List {
                if locationData.tags.count > 0 {
                    DetailRowView(label: "Tags", content: locationData.tags.joined(separator: ", "))
                }
                if locationData.radius != nil {
                    DetailRowView(label: "Radius", content: locationData.radius?.description ?? "")
                }
                DetailRowView(label: "Wellbeing", content: locationData.subjectiveWellbeing.description)
                if locationData.db != nil {
                    DetailRowView(label: "Loudness", content: "\(locationData.db!.description) dB")
                }
            }
                    .navigationBarTitle(Text("Details"), displayMode: .inline)
                    .navigationBarItems(trailing: Button(action: {
                        dismiss()
                    }) {
                        Text("Close").bold()
                    })
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
