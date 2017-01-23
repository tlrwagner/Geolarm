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
import AVFoundation
import AudioToolbox

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func playSoundTest(_ sender: AnyObject) {
        AudioServicesPlaySystemSound(SystemSoundID(1304))
    }
    
    var resultSearchController: UISearchController? = nil
    
    
    var locationManager = CLLocationManager()
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier:"LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchbar = resultSearchController!.searchBar
        searchbar.sizeToFit()
        searchbar.placeholder = "Search for destination"
        navigationItem.titleView = resultSearchController!.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .notDetermined || CLLocationManager.authorizationStatus() == .restricted {
            self.locationManager.requestAlwaysAuthorization()
        }
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        let long = userLocation.coordinate.longitude;
        let lat = userLocation.coordinate.latitude;
        let newLocation = CLLocation(latitude: lat, longitude: long)
        centerMapOnLocation(newLocation)
        
        print(long, lat)
    }
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error){
        print(error)
    }
}
