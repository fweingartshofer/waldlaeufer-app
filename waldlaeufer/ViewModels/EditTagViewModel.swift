//
// Created by Andreas Wenzelhuemer on 28.01.23.
//

import Foundation
import FirebaseFirestore

class EditTagViewModel: ObservableObject {

    var allSearchResults: [Tag] = []

    @Published var currentTagName: String = ""
    @Published var searchResults: [Tag] = []

    private let tagService = TagService()

    func start() {
        tagService.find().addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            self.allSearchResults = documents.map { queryDocumentSnapshot -> Tag in
                let data = queryDocumentSnapshot.data()
                let name = data["name"] as? String ?? ""
                return Tag(id: queryDocumentSnapshot.documentID, name: name)
            }
        }
    }

    func search(_ value: String, tagsToExclude: [Tag]) {
        searchResults = allSearchResults.filter { result in
            result.name.localizedCaseInsensitiveContains(value)
            && !tagsToExclude.contains{ ex in ex.name.caseInsensitiveCompare(result.name) == .orderedSame }
        }
    }
}