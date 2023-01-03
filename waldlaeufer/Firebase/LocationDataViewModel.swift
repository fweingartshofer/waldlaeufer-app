//
// Created by Florian Weingartshofer on 29.12.22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import GeoFire
import GeoFireUtils
import CoreLocation

class LocationDataViewModel: ObservableObject {

    @Published var locationData = [LocationData]()
    private let ref = Firestore.firestore().collection("LocationData")

    // depending on zoom level needs to be set over function parameters
    private let range = 20.0

    func findInArea(geoLocation: GeoLocation) {
        print(geoLocation)
        let center = geoLocation.asCLLocationCoordinate2D()
        let radiusInM: Double = 50 * 1000
        let queryBounds = GFUtils.queryBounds(forLocation: center,
                withRadius: radiusInM)
        let queries = queryBounds.map { bound -> Query in
            ref.order(by: "geoLocation")
                    .start(at: [bound.startValue])
                    .end(at: [bound.endValue])
        }

        var matchingDocs = [QueryDocumentSnapshot]()
        // Collect all the query results together into a single list
        func getDocumentsCompletion(snapshot: QuerySnapshot?, error: Error?) -> () {
            guard let documents = snapshot?.documents else {
                print("Unable to fetch snapshot data. \(String(describing: error))")
                return
            }

            for document in documents {
                //TODO: Validate with geoPoint
                let lat = document.data()["latitude"] as? Double ?? 0
                let lng = document.data()["longitude"] as? Double ?? 0
                let coordinates = CLLocation(latitude: lat, longitude: lng)
                let centerPoint = CLLocation(latitude: center.latitude, longitude: center.longitude)

                // We have to filter out a few false positives due to GeoHash accuracy, but
                // most will match
                let distance = GFUtils.distance(from: centerPoint, to: coordinates)
                if distance <= radiusInM {
                    matchingDocs.append(document)
                }
            }
        }

        // After all callbacks have executed, matchingDocs contains the result. Note that this
        // sample does not demonstrate how to wait on all callbacks to complete.
        for query in queries {
            query.getDocuments(completion: getDocumentsCompletion)
        }

        locationData = matchingDocs.map { (queryDocumentSnapshot) -> LocationData in
            let data = queryDocumentSnapshot.data()
            return mapGeoLocationFromDictionary(data: data)
        }
    }

    func insert(locationData: LocationData) {
        do {
            try ref.document().setData(from: LocationDataDtoForCreation(ld: locationData))
        } catch let error {
            print("Error writing document: \(error)")
        }
    }
}

struct LocationDataDtoForCreation: Encodable {
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
