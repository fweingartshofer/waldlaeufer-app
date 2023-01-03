//
// Created by Florian Weingartshofer on 29.12.22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class LocationDataViewModel : ObservableObject {

    @Published var locationData = [LocationData]()
    private let db = Firestore.firestore()

    // depending on zoom level needs to be set over function parameters
    private let range = 20.0

    func findInArea(geoLocation: GeoLocation) {
        print(geoLocation)
        db.collection("LocationData")
                //.whereField("geoLocation.longitude", isGreaterThan: geoLocation.longitude - range)
                //.whereField("geoLocation.longitude", isLessThan: geoLocation.longitude + range)
                //.whereField("geoLocation.latitude", isGreaterThan: geoLocation.latitude - range)
                //.whereField("geoLocation.latitude", isLessThan: geoLocation.latitude + range)
                .addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            self.locationData = documents.map { (queryDocumentSnapshot) -> LocationData in
                let data = queryDocumentSnapshot.data()
                let timestamp = data["timestamp"] as! Timestamp
                let seconds = Double(timestamp.seconds)
                let nanoseconds = Double(timestamp.nanoseconds) / 1_000_000_000

                let subjectiveWellbeing = data["subjectiveWellbeing"] as! Int
                let geoPoint = data["geoLocation"] as! GeoPoint
                let db = data["db"] as? Float
                let radius = data["radius"] as? Float
                let tags = data["tags"] as! [String]

                return LocationData(
                        timestamp: Date(timeIntervalSince1970: seconds + nanoseconds),
                        subjectiveWellbeing: SubjectiveWellbeing(rawValue: subjectiveWellbeing)!,
                        geoLocation: GeoLocation(latitude: geoPoint.latitude, longitude: geoPoint.longitude),
                        db: db,
                        radius: radius,
                        tags: tags)
            }
        }
    }

    func insert(locationData: LocationData) {
        // TODO Insert locationData
    }
}
