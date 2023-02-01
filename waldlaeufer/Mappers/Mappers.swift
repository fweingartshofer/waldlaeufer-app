//
// Created by Florian Weingartshofer on 03.01.23.
//

import Foundation
import FirebaseFirestore

func mapGeoLocationFromDictionary(data: [String: Any]) -> LocationData {
    let id = data["id"] as! String
    let timestamp = data["timestamp"] as! Timestamp
    let subjectiveWellbeing = data["subjectiveWellbeing"] as! Int
    let geoPoint = data["geoPoint"] as! GeoPoint
    let db = data["db"] as? Float
    let radius = data["radius"] as? Float
    let tagIds = data["tagIds"] as? [String]

    return LocationData(
            id: id,
            timestamp: timestamp.dateValue(),
            subjectiveWellbeing: SubjectiveWellbeing(rawValue: subjectiveWellbeing)!,
            geoLocation: GeoLocation(geoPoint: geoPoint),
            db: db,
            radius: radius,
            tags:  tagIds?.map { Tag(id: $0, name: "") } ?? []
    )
}

func mapDbAndStressLevelToWellbeing(db: Float?, stressLevel: Double?) -> SubjectiveWellbeing {
    var dbWeight: Float = 0
    var stressWeight: Float = 0
    var normalizedDb: Float = 0
    var normalizedStress: Float = 0

    if let db = db {
        normalizedDb = db / 140
        if db < 50 {
            normalizedDb = 0
        } else if db < 60 {
            normalizedDb = 0.33
        } else if db < 75 {
            normalizedDb = 0.66
        } else {
            normalizedDb = 0.99
        }
        dbWeight = 0.5
    }
    if let stressLevel = stressLevel {
        normalizedStress = Float(stressLevel)
        stressWeight = 1 - dbWeight
    } else {
        dbWeight = 1
    }

    let combinedMetric: Float = dbWeight * normalizedDb + stressWeight * normalizedStress

    let binIntervals: [Float] = [0.125, 0.25, 0.5, 0.75]
    for (index, interval) in binIntervals.enumerated() {
        if combinedMetric <= interval {
            return SubjectiveWellbeing(rawValue: index)!
        }
    }
    return SubjectiveWellbeing.GOOD
}