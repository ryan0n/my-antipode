//
//  ViewController.swift
//  myAntipode
//
//  Created by Ryan Wright on 12/17/17.
//  Copyright © 2017 Ryan Wright. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    let regionRadius: CLLocationDistance = 1000
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO:Set up the location manager here.
        
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        centerMapOnLocation(location: initialLocation)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            print("before lat: \(location.coordinate.latitude), long: \(location.coordinate.longitude)")
            
            var newLat : Double = 0.0
            var newLong : Double = 0.0
            
            newLat = location.coordinate.latitude * -1.0
            
            newLong = location.coordinate.longitude
            
            newLong = 180.0 - abs(location.coordinate.longitude)
            
            if location.coordinate.longitude > 0 {
                newLong = newLong * -1.0
            }
            
            print("after lat: \(newLat), long: \(newLong)")
            centerMapOnLocation(location: CLLocation(latitude: newLat, longitude: newLong))
        }
    }
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

}

