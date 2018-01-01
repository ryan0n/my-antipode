import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    var selectedSavedLocation : SavedLocation?

    let regionRadius: CLLocationDistance = 5000
    
    let locationManager = CLLocationManager()
    var centerOnAntipode : Bool = true
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scale = MKScaleView(mapView: mapView)
        scale.scaleVisibility = .visible
        view.addSubview(scale)
        
        recenter()
    }
    
    func recenter() {
        // Run this if the selectedSavedLocation set before the previous segue
        // is actually just the current location.
        if selectedSavedLocation == nil {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            centerMapOnLocation(location: getLocationForMap(latitude: selectedSavedLocation!.latitude, longitude: selectedSavedLocation!.longitude))
        }
    }

    func getLocationForMap(latitude: Double, longitude: Double) -> CLLocation {
        var newLat : Double = latitude
        var newLong : Double = longitude

        if centerOnAntipode {
            newLat = latitude * -1.0
            newLong = longitude
            newLong = 180.0 - abs(longitude)
            if longitude > 0 {
                newLong = newLong * -1.0
            }
        }
        
        return  CLLocation(latitude: newLat, longitude: newLong)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            centerMapOnLocation(location: getLocationForMap(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
        }
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func switchAntipodeModeButtonPressed(_ sender: UIButton) {
        centerOnAntipode = !centerOnAntipode
        recenter()
    }
    
    
}

