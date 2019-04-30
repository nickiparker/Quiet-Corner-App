//
//  LocationDetailsViewController.swift
//  Quiet-Corner
//
//  Created by NICKI PARKER on 26/04/2019.
//  Copyright © 2019 Nickiparker. All rights reserved.
//

import UIKit
import SDWebImage
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation

class LocationDetailsViewController: UIViewController, SDWebImageManagerDelegate {

    @IBOutlet var goNavigationButton: UIButton!
    
    // To help get users current long/lat coordinates
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var advertImage: UIImageView! {
        didSet {
            advertImage.contentMode = .scaleAspectFill
            advertImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var locationImage: UIImageView! {
        didSet {
            let gradient = CAGradientLayer()
            gradient.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor, UIColor.clear.cgColor]
            gradient.locations = [0.0, 1.0]
            
            gradient.startPoint = CGPoint(x: 0, y: 1)
            gradient.endPoint = CGPoint(x: 0, y: 0)
            gradient.frame = CGRect(x: 0,
                                    y: 0,
                                    width: UIScreen.main.bounds.width,
                                    height: locationImage.bounds.height)
            
            locationImage.layer.insertSublayer(gradient, at: 0)
            locationImage.contentMode = .scaleAspectFill
            locationImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var locationDescription: UILabel!
    @IBOutlet weak var journeyTime: UILabel!
    @IBOutlet weak var journeyDistance: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationLabel.text = location[0].location
        locationDescription.text = location[0].description
        
        goNavigationButton.applyDesign()
        
        SDWebImageManager.shared().delegate = self
        SDWebImageManager.shared().loadImage(with: URL(string: location[0].imageURL), options: [], progress: nil) { (image, data, error, cacheType, finished, url) in
            // Do something
            self.locationImage.image = image
        }
        
//        SDWebImageManager.shared().loadImage(with: URL(string: "https://static2.bigstockphoto.com/2/6/2/large1500/262292797.jpg"), options: [], progress: nil) { (image, data, error, cacheType, finished, url) in
//            // Do something
//            self.advertImage.image = image
//        }
        
        // Display advert for Locations that have paid for advertising
        if location[0].location == "Porthcurno Beach" {
            self.advertImage.image = UIImage(named: "porthcurno-advert")
        } else if location[0].location == "St Michael’s Mount" {
             self.advertImage.image = UIImage(named: "st-michaels-mount-advert")
        } else if location[0].location == "Trebah Garden" {
             self.advertImage.image = UIImage(named: "trebah-advert")
        } else {
            self.advertImage.isHidden = true
        }
        
        // Add journey distance and travel time
        // This needs to be set to users current location
        locManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locManager.location else {
                return
            }
            
            // Set lat/longs for location and current position
            let currentLat = currentLocation.coordinate.latitude
            let currentLong = currentLocation.coordinate.longitude
            let locationLat = Double(location[0].latitude)
            let locationLong = Double(location[0].longitude)
            let locationName = location[0].location
            
            let origin = Waypoint(coordinate: CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong), name: "Your Location")
            let destination = Waypoint(coordinate: CLLocationCoordinate2D(latitude: locationLat ?? currentLat, longitude: locationLong ?? currentLong), name: locationName)
            
            let options = NavigationRouteOptions(waypoints: [origin, destination])
            
            Directions.shared.calculate(options) { (waypoints, routes, error) in
                guard let route = routes?.first else { return }
                
                let locationDistanceMiles = lround(route.distance / 1609.344)
                let locationTravelTime = lround(route.expectedTravelTime / 60)
                
                self.journeyTime.text = String(locationTravelTime) + " Mins"
                self.journeyDistance.text = String(locationDistanceMiles) + " Miles"
            }
        }
    }
    
    // Resize image from url to be consistent with UIImageView
    func imageManager(_ imageManager: SDWebImageManager, transformDownloadedImage image: UIImage?, with imageURL: URL?) -> UIImage? {
        guard let image = image, let imageURL = imageURL else {
            return nil
        }
        if (imageURL.lastPathComponent == "large" && (image.size.width > 1000 || image.size.width > 1000)) {
            let targetSize = CGSize(width: 1000, height: 1000)
            UIGraphicsBeginImageContextWithOptions(targetSize, !SDCGImageRefContainsAlpha(image.cgImage), image.scale)
            image.draw(in: CGRect(origin: .zero, size: targetSize))
            
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return scaledImage
        } else {
            return image
        }
    }
    
    @IBAction func goToNavigation(_ sender: Any) {
        
        // This needs to be set to users current location
        locManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locManager.location else {
                return
            }
           
            // Set lat/longs for location and current position
            let currentLat = currentLocation.coordinate.latitude
            let currentLong = currentLocation.coordinate.longitude
            let locationLat = Double(location[0].latitude)
            let locationLong = Double(location[0].longitude)
            let locationName = location[0].location
            
            let origin = Waypoint(coordinate: CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong), name: "Your Location")
            let destination = Waypoint(coordinate: CLLocationCoordinate2D(latitude: locationLat ?? currentLat, longitude: locationLong ?? currentLong), name: locationName)
            
            let options = NavigationRouteOptions(waypoints: [origin, destination])
            
            Directions.shared.calculate(options) { (waypoints, routes, error) in
                guard let route = routes?.first else { return }
                
                let viewController = NavigationViewController(for: route)
                self.present(viewController, animated: true, completion: nil)
            }
        }

    }
}
