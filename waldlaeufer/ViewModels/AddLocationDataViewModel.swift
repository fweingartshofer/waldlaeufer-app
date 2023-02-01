//
// Created by Florian Weingartshofer on 27.01.23.
//

import Foundation
import FirebaseFirestore

final class AddLocationDataViewModel: ObservableObject {

    private let healthService = HealthStoreService()
    private let tagService = TagService()
    private let locationDataService = LocationDataService()

    @Published var state: State = .form

    enum State {
        case form
        case saving
        case customMap
    }

    func getStressLevel() -> Double? {
            healthService.hasStress
                    ? healthService.averageStressLevel()
                    : nil
    }

    func insert(locationData: LocationData) {
        do {
            state = .saving
            let tags = try tagService.insertTags(tags: locationData.tags)
            var locationDataToInsert = locationData
            locationDataToInsert.tags = tags
            try locationDataService.insert(data: locationDataToInsert)
        } catch let error {
            print("Error writing document: \(error)")
        }
    }
}