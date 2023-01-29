//
// Created by Florian Weingartshofer on 27.01.23.
//

import Foundation
import FirebaseFirestore

final class AddLocationDataViewModel: ObservableObject {

    @Published var state: State = .form

    enum State {
        case form
        case saving
        case customMap
    }

    private func insertTags(tags: [Tag]) throws -> [Tag] {
        try tags.map { tag in
            if tag.id == nil {
                let ref = Firestore.firestore().collection("Tags").document()
                let id = ref.documentID
                try ref.setData(from: tag)
                return Tag(id: id, name: tag.name)
            } else {
                return tag
            }
        }
    }

    func insert(locationData: LocationData) {
        do {
            state = .saving
            let tags = try insertTags(tags: locationData.tags)

            try Firestore.firestore().collection("LocationData").document()
                    .setData(from: LocationDataForCreation(ld: locationData, tags: tags))
        } catch let error {
            print("Error writing document: \(error)")
        }
    }
}