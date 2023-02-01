//
// Created by Florian Weingartshofer on 01.02.23.
//

import Foundation
import FirebaseFirestore

class TagService {
    private let ref = Firestore.firestore().collection("Tags")

    public func getTagsByIds(ids: [String]) -> Query {
        ref.whereField(FieldPath.documentID(), in: ids)
    }

    public func getTags() -> CollectionReference {
        ref
    }

    public func insertTags(tags: [Tag]) throws -> [Tag] {
        try tags.map { tag in
            if tag.id == nil {
                let document = ref.document()
                let id = document.documentID
                try document.setData(from: tag)
                return Tag(id: id, name: tag.name)
            } else {
                return tag
            }
        }
    }
}