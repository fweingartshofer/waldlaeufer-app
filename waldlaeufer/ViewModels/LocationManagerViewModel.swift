import Foundation
import Logging
import CoreLocation
import MapKit

final class LocationManagerViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {

    let logger = Logger(label: "LocationManagerViewModel")

    @Published var region = MKCoordinateRegion()

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    deinit {
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.last.map {
            logger.log(level: .info, "Changes \($0)")
            region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                            latitude: $0.coordinate.latitude,
                            longitude: $0.coordinate.longitude
                    ),
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
        }
    }
}