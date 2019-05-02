//
//  MapViewController.swift
//  Quiet-Corner
//
//  Created by NICKI PARKER on 28/04/2019.
//  Copyright © 2019 Nickiparker. All rights reserved.
//

import UIKit
import Mapbox
import Firebase

// MGLPointAnnotation subclass
class MyCustomPointAnnotation: MGLPointAnnotation {
    var willUseImage: Bool = false
}

// end MGLPointAnnotation subclass

class MapViewController: UIViewController, MGLMapViewDelegate {
    
    var locations: [Location] = []
    
    // To help get users current long/lat coordinates
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Create a new map view using the Mapbox Light style.
        let mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.lightStyleURL)
        
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // This needs to be set to users current location
        locManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            let currentLocation = locManager.location
            
            // Set lat/longs for location and current position
            let currentLat = currentLocation!.coordinate.latitude
            let currentLong = currentLocation!.coordinate.longitude
            
            // Allow the map view to display the user's location
            mapView.showsUserLocation = true
            
            // Set the map’s center coordinate and zoom level.
            mapView.setCenter(CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong), zoomLevel: 8.5, animated: false)
            view.addSubview(mapView)
        }
        
        mapView.delegate = self
        
        // Access locations via tab bar controller
        let tabBar = tabBarController as! TabBarController
        var myLocations: Array<MyCustomPointAnnotation> = []
        
       
        for location in tabBar.locations {
            let point = MyCustomPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: Double(location.latitude)!, longitude: Double(location.longitude)!)
            point.title = location.location
            
            // Display advert for Locations that have paid for advertising
            if location.location == "Porthcurno Beach" {
                point.willUseImage = false
            } else if location.location == "St Michael’s Mount" {
                point.willUseImage = false
            } else if location.location == "Trebah Garden" {
                point.willUseImage = false
            } else {
                point.willUseImage = true
            }
            //point.willUseImage = false
            myLocations.append(point)
        }
        
        // Add all annotations to the map all at once, instead of individually.
        mapView.addAnnotations(myLocations)
    }
    
    // This delegate method is where you tell the map to load a view for a specific annotation based on the willUseImage property of the custom subclass.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        
        if let castAnnotation = annotation as? MyCustomPointAnnotation {
            if (castAnnotation.willUseImage) {
                return nil
            }
        }
        
        // Assign a reuse identifier to be used by both of the annotation views, taking advantage of their similarities.
        let reuseIdentifier = "reusableDotView"
        
        // For better performance, always try to reuse existing annotations.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
            annotationView = MGLAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            annotationView?.layer.cornerRadius = (annotationView?.frame.size.width)! / 2
            annotationView?.layer.borderWidth = 4.0
            annotationView?.layer.borderColor = UIColor.white.cgColor
            annotationView!.backgroundColor = UIColor(red: 0.03, green: 0.80, blue: 0.69, alpha: 1.0)
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped.
        return true
    }
    
}
