//
// Created by Florian Weingartshofer on 29.12.22.
//

import Foundation

public protocol LocationDataRepository {
    func findInArea(geoLocation: GeoLocation) -> Array<LocationData>;
    func insert(locationData: LocationData);
}