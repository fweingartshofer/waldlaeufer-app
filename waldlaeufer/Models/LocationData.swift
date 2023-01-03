//
// Created by Florian Weingartshofer on 29.12.22.
//

import Foundation

struct GeoLocation: Codable {
    let latitude: Double
    let longitude: Double
}

struct LocationData: Identifiable, Codable {
    let id: String = UUID().uuidString
    let timestamp: Date
    let subjectiveWellbeing: SubjectiveWellbeing
    let geoLocation: GeoLocation
    let db: Float?
    let radius: Float?
    let tags: Array<String>
}
