//
// Created by Andreas Wenzelhuemer on 28.01.23.
//

import Foundation
import FirebaseFirestore

class LocationDataDetailViewModel: ObservableObject {

    private let ref = Firestore.firestore().collection("Tags")

    @Published var state: State = .loading

    enum State: Equatable {
        case loading
        case finished(tags: [String])
    }

    func start(ld: LocationData) {
        state = .loading

        if ld.tags.count == 0 {
            state = .finished(tags: [])
        } else {
            ref.whereField(FieldPath.documentID(), in: ld.tags.map {
                        $0.id!
                    })
                    .addSnapshotListener { (querySnapshot, error) in
                        guard let documents = querySnapshot?.documents else {
                            print("No documents")
                            return
                        }
                        self.state = .finished(tags: documents.map { queryDocumentSnapshot -> String in
                            let data = queryDocumentSnapshot.data()
                            return data["name"] as? String ?? ""
                        })
                    }
        }
    }
}