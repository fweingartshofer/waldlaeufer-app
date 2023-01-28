//
// Created by Florian Weingartshofer on 27.01.23.
//

import Foundation
import FirebaseFirestore
import GeoFireUtils

struct LocationDataForCreation: Encodable {
    let id: String?
    let timestamp: Date
    let subjectiveWellbeing: SubjectiveWellbeing
    let geoHash: String
    let geoPoint: GeoPoint
    let db: Float?
    let radius: Float?
    let tags: Array<String>

    public init(ld: LocationData) {
        id = ld.id
        timestamp = ld.timestamp
        subjectiveWellbeing = ld.subjectiveWellbeing
        geoHash = GFUtils.geoHash(forLocation: ld.geoLocation.asCLLocationCoordinate2D())
        geoPoint = ld.geoLocation.asGeoPoint()
        db = ld.db
        radius = ld.radius
        tags = ld.tags
    }
}