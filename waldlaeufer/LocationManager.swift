import Foundation
import Logging
import CoreLocation
import MapKit

class LocationManager : NSObject, ObservableObject, CLLocationManagerDelegate {

    let logger = Logger(label: "LocationManager")

    @Published var region = MKCoordinateRegion()

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.last.map {
            logger.log(level: .error, "Changes \($0)")
            region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                            latitude: $0.coordinate.latitude,
                            longitude: $0.coordinate.longitude
                    ),
                    span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            )
        }
    }
}