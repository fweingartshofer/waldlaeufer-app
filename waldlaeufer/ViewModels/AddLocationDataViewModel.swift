//
// Created by Florian Weingartshofer on 27.01.23.
//

import Foundation
import FirebaseFirestore

final class AddLocationDataViewModel: ObservableObject {

    private let ref = Firestore.firestore().collection("LocationData")

    func insert(locationData: LocationData) {
        do {
            try ref.document().setData(from: LocationDataForCreation(ld: locationData))
        } catch let error {
            print("Error writing document: \(error)")
        }
    }
}