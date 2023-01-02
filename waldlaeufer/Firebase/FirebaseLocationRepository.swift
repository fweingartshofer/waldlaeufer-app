//
// Created by Florian Weingartshofer on 29.12.22.
//

import Foundation
import FirebaseFirestore


class FirebaseLocationRepository: LocationDataRepository {
    private var locationDataRef = Firestore.firestore().collection("LocationData");


    func findInArea(geoLocation: GeoLocation) -> Array<LocationData> {
        return Array()
    }

    func insert(locationData: LocationData) {

    }
    
    func test() {
        locationDataRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }

}
