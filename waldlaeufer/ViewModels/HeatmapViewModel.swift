//
// Created by Florian Weingartshofer on 29.12.22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import GeoFire
import GeoFireUtils
import CoreLocation
import Logging

final class HeatmapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate  {

    let logger = Logger(label: "LocationDataViewModel")

    @Published var region = MKCoordinateRegion()
    @Published var locationData = [LocationData]()

    private let ref = Firestore.firestore().collection("LocationData")

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    deinit {
        manager.stopUpdatingLocation()
    }

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
                let geoPoint = document.data()["geoPoint"] as? GeoPoint
                guard let geoPoint = geoPoint else {
                    print(document)
                    continue
                }
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

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.last.map {
            logger.log(level: .info, "Changes \($0)")
            region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                            latitude: $0.coordinate.latitude,
                            longitude: $0.coordinate.longitude
                    ),
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
        }
    }
}
