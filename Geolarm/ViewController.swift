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

protocol HandleMapSearch {
    func dropPinZoom(placemark:MKPlacemark)
}

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func playSoundTest(_ sender: AnyObject) {
        AudioServicesPlaySystemSound(SystemSoundID(1304))
    }
    let alertController = UIAlertController(title: "We're Here!", message: "You have arrived at your destination", preferredStyle: UIAlertControllerStyle.alert)
    
    //    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
    //    {
    //        locationManager.stopUpdatingLocation()
    //        (result : UIAlertAction) -> Void in
    //        print("You pressed OK")
    //    }
    
    func playAlarm(){
        AudioServicesPlaySystemSound(SystemSoundID(1304))
    }
    
    var resultSearchController: UISearchController? = nil
    var selectedPin: MKPlacemark? = nil
    
    var isFollowingUser = true
    
    var locationManager = CLLocationManager()
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius )
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
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        {
            
            (result : UIAlertAction) -> Void in
            print("You pressed OK")
        }
        alertController.addAction(okAction)
        
        //        locationManager.stopUpdatingLocation()
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        let long = userLocation.coordinate.longitude;
        let lat = userLocation.coordinate.latitude;
        let newLocation = CLLocation(latitude: lat, longitude: long)
        
        if isFollowingUser{
            centerMapOnLocation(userLocation)
        }
        
        print(long, lat)
        if selectedPin != nil{
            //            print(selectedPin?.coordinate)
            //            print(newLocation.coordinate)
            let pinLocation = CLLocation(latitude: (selectedPin?.coordinate.latitude)!, longitude: (selectedPin?.coordinate.longitude)!)
            if userLocation.distance(from: pinLocation) < 50{
                print("reached location!!!")
//                locationManager.stopUpdatingLocation()
                playAlarm()
                self.present(alertController, animated: true, completion: nil)
                mapView.removeAnnotations(mapView.annotations)
            }
            //            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error){
        print(error)
    }
}

extension ViewController: HandleMapSearch{
    func dropPinZoom(placemark: MKPlacemark) {
        //cache pin
        selectedPin = placemark
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.title
        if let city = placemark.locality, let state = placemark.administrativeArea{
            annotation.subtitle = "(city) (state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}
