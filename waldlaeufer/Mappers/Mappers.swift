//
// Created by Florian Weingartshofer on 03.01.23.
//

import Foundation
import FirebaseFirestore

func mapGeoLocationFromDictionary(data: [String: Any]) -> LocationData {
    print(data)
    let id = data["id"] as! String
    let timestamp = data["timestamp"] as! Timestamp
    let subjectiveWellbeing = data["subjectiveWellbeing"] as! Int
    let geoPoint = data["geoPoint"] as! GeoPoint
    let db = data["db"] as? Float
    let radius = data["radius"] as? Float
    let tags = data["tags"] as! [String]

    return LocationData(
            id: id,
            timestamp: timestamp.dateValue(),
            subjectiveWellbeing: SubjectiveWellbeing(rawValue: subjectiveWellbeing)!,
            geoLocation: GeoLocation(geoPoint: geoPoint),
            db: db,
            radius: radius,
            tags: tags)
}