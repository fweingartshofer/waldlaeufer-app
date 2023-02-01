//
// Created by Florian Weingartshofer on 01.02.23.
//

import Foundation
import FirebaseFirestore
import GeoFireUtils

class LocationDataService {

    private let ref = Firestore.firestore().collection("LocationData")

    public func insert(data: LocationData) throws {
        try ref.document()
                .setData(from: LocationDataForCreation(ld: data))
    }

    public func findByGeoLocation(geoLocation: GeoLocation, radiusInM: Double) -> [Query] {
        let center = geoLocation.asCLLocationCoordinate2D()
        let queryBounds = GFUtils.queryBounds(forLocation: center,
                withRadius: radiusInM)

        return queryBounds.map { bound -> Query in
            ref.order(by: "geoHash")
                    .start(at: [bound.startValue])
                    .end(at: [bound.endValue])
        }
    }

}
