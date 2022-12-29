//
// Created by Florian Weingartshofer on 29.12.22.
//

import Foundation

public typealias GeoLocation = (latitude: Double, longitude: Double)

public enum SubjectiveWellbeing {
    case REALLY_GOOD
    case GOOD
    case BAD
    case REALLY_BAD
}

public class LocationData {
    private var timestamp: Date;
    private var subjectiveWellbeing: SubjectiveWellbeing;
    private var geoLocation: GeoLocation;
    private var db: Float?;
    private var radius: Float?;
    private var tags: Array<String>;

    public init(timestamp: Date,
                subjectiveWellbeing: SubjectiveWellbeing,
                geoLocation: GeoLocation,
                db: Float?,
                radius: Float?,
                tags: Array<String>) {
        self.timestamp = timestamp
        self.subjectiveWellbeing = subjectiveWellbeing
        self.geoLocation = geoLocation
        self.db = db
        self.radius = radius
        self.tags = tags
    }
}
