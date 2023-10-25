import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()

    @Published var location: CLLocation?


    override init() {
        super.init()

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        self.locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        self.locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = location
           
          
        }
    }
}
