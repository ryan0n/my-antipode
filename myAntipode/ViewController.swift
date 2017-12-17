import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    let regionRadius: CLLocationDistance = 1000
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            
            var newLat : Double = 0.0
            var newLong : Double = 0.0
            
            newLat = location.coordinate.latitude * -1.0
            
            newLong = location.coordinate.longitude
            
            newLong = 180.0 - abs(location.coordinate.longitude)
            
            if location.coordinate.longitude > 0 {
                newLong = newLong * -1.0
            }

            centerMapOnLocation(location: CLLocation(latitude: newLat, longitude: newLong))
        }
    }
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

}

