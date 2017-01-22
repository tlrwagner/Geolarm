//
//  ViewController.swift
//  Geolarm
//
//  Created by Tyler Wagner on 1/21/17.
//  Copyright © 2017 Tyler Wagner. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    //comment for initial commit
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func showSearchBar(sender: AnyObject) {
        
    }
    
    
    var locationManager = CLLocationManager()
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func locButton(sender: AnyObject) {
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .NotDetermined || CLLocationManager.authorizationStatus() == .Restricted {
            self.locationManager.requestAlwaysAuthorization()
        }
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        let long = userLocation.coordinate.longitude;
        let lat = userLocation.coordinate.latitude;
        let newLocation = CLLocation(latitude: lat, longitude: long)
        centerMapOnLocation(newLocation)
        
        print(long, lat)
        
        //Do What ever you want with it
    }
    func locationManager(manager: CLLocationManager,
        didFailWithError error: ErrorType){
            print(error)
    }
}