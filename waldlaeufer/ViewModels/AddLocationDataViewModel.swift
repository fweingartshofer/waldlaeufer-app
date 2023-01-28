//
// Created by Florian Weingartshofer on 27.01.23.
//

import Foundation
import FirebaseFirestore

final class AddLocationDataViewModel: ObservableObject {

    func insert(locationData: LocationData) {
        do {

            let tags = try locationData.tags.map { tag in
                        if tag.id == nil {
                            let ref = Firestore.firestore().collection("Tags").document()
                            let id = ref.documentID
                            try ref.setData(from: tag)
                            return Tag(id: id, name: tag.name)
                        } else {
                            return tag
                        }
                    }

            try Firestore.firestore().collection("LocationData").document()
                    .setData(from: LocationDataForCreation(ld: locationData, tags: tags))
        } catch let error {
            print("Error writing document: \(error)")
        }
    }
}