//
// Created by Florian Weingartshofer on 29.12.22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import GeoFire
import GeoFireUtils
import CoreLocation

final class LocationDataViewModel: ObservableObject {

    @Published var locationData = [LocationData]()
    private let ref = Firestore.firestore().collection("LocationData")

    func findInArea(geoLocation: GeoLocation) {
        let center = geoLocation.asCLLocationCoordinate2D()
        let radiusInM: Double = 5 * 1000
        let queryBounds = GFUtils.queryBounds(forLocation: center,
                withRadius: radiusInM)
        let queries = queryBounds.map { bound -> Query in
            ref.order(by: "geoHash")
                    .start(at: [bound.startValue])
                    .end(at: [bound.endValue])
        }

        func getDocumentsCompletion(snapshot: QuerySnapshot?, error: Error?) -> () {
            guard let documents = snapshot?.documents else {
                print("Unable to fetch snapshot data. \(String(describing: error))")
                return
            }

            for document in documents {
                let geoPoint = document.data()["geoPoint"] as! GeoPoint
                let coordinates = CLLocation(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
                let centerPoint = CLLocation(latitude: center.latitude, longitude: center.longitude)

                // We have to filter out a few false positives due to GeoHash accuracy, but
                // most will match
                let distance = GFUtils.distance(from: centerPoint, to: coordinates)
                if distance <= radiusInM {
                    var data = document.data()
                    let index = locationData.firstIndex(where: { $0.id == document.documentID })
                    if index != nil {
                        locationData.remove(at: index!)
                    }
                    data["id"] = document.documentID

                    locationData.append(mapGeoLocationFromDictionary(data: data))
                }
            }
        }

        // After all callbacks have executed, matchingDocs contains the result. Note that this
        // sample does not demonstrate how to wait on all callbacks to complete.
        for query in queries {
            query.addSnapshotListener(getDocumentsCompletion)
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
