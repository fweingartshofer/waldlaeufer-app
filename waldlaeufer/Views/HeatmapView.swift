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

    var body: some View {
        Map(coordinateRegion: $manager.region, showsUserLocation: true, userTrackingMode: .constant(.follow))
    }
}

struct HeatmapView_Previews: PreviewProvider {
    static var previews: some View {
        HeatmapView()
    }
}
