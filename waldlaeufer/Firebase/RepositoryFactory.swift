//
// Created by Andreas Wenzelhuemer on 02.01.23.
//

import Foundation

class RepositoryFactory {

    private static var locationDataRepository: LocationDataRepository? = nil;

    static func getFirebaseLocationRepository() -> LocationDataRepository {
        if locationDataRepository == nil {
            locationDataRepository = FirebaseLocationRepository();
        }
        return locationDataRepository!;
    }
}