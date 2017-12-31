import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    let regionRadius: CLLocationDistance = 1000
    let locationManager = CLLocationManager()
    var centerOnMyLocation : Bool = false
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("LocationHistoryItems.plist")
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapType = MKMapType.hybrid
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            
            locationManager.stopUpdatingLocation()
            var newLat : Double = 0.0
            var newLong : Double = 0.0
            
            if centerOnMyLocation {
                newLat = location.coordinate.latitude
                newLong = location.coordinate.longitude
            } else {
                newLat = location.coordinate.latitude * -1.0
                
                newLong = location.coordinate.longitude
                
                newLong = 180.0 - abs(location.coordinate.longitude)
                
                if location.coordinate.longitude > 0 {
                    newLong = newLong * -1.0
                }
            }
            centerMapOnLocation(location: CLLocation(latitude: newLat, longitude: newLong))
        }
    }
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    @IBAction func myLocationButtonPressed(_ sender: Any) {
        centerOnMyLocation = true
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func myAntipodeButtonPressed(_ sender: Any) {
        centerOnMyLocation = false
        locationManager.startUpdatingLocation()
    }
    
    func loadItems() {
        /*
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                locationHistoryItemArray = try decoder.decode([LocationHistoryItem].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
        print(locationHistoryItemArray)
 */
    }
    
    func saveItems() {
        /*
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(locationHistoryItemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        // self.tableView.reloadData()
 */
    }

    
}

