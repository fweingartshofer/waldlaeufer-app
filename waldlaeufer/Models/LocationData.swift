//
// Created by Florian Weingartshofer on 29.12.22.
//

import Foundation
import FirebaseFirestore
import CoreLocation
import MapKit

struct GeoLocation: Codable {
    let latitude: Double
    let longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

    public init(geoPoint: GeoPoint) {
        self.init(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
    }

    public init(coordinates: CLLocationCoordinate2D) {
        self.init(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }

    public init(coordinates: MKCoordinateRegion) {
        self.init(latitude: coordinates.center.latitude, longitude: coordinates.center.longitude)
    }

    public func asGeoPoint() -> GeoPoint {
        GeoPoint(latitude: latitude, longitude: longitude)
    }

    public func asCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct LocationData: Identifiable, Codable {
    let id: String?
    let timestamp: Date
    let subjectiveWellbeing: SubjectiveWellbeing
    let geoLocation: GeoLocation
    let db: Float?
    let radius: Float?
    let tags: Array<Tag>
}
