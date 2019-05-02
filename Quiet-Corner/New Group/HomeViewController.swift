//
//  HomeTableViewController.swift
//  Quiet-Corner
//
//  Created by NICKI PARKER on 08/04/2019.
//  Copyright © 2019 Nickiparker. All rights reserved.
//

import UIKit
import Firebase
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation
import SDWebImage

var location: [Location] = []

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SDWebImageManagerDelegate {
    
    // locations firebase
    let db = Firestore.firestore()
    private var documents: [DocumentSnapshot] = []
    public var locations: [Location] = []
    
    // To help get users current long/lat coordinates
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    @IBOutlet var tableView: UITableView!
    
    @IBAction func didTapFilterButton(_ sender: Any) {
        present(filter.navigationController, animated: true, completion: nil)
    }
    
    @IBOutlet var filterButton: UIButton!
 
    // Firebase global setter to constrain firebase query to max 50
    fileprivate func baseQuery() -> Query {
        return Firestore.firestore().collection("locations").limit(to: 50)
    }
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeQuery()
            }
        }
    }
    
    lazy private var filter: (navigationController: UINavigationController,
        filterController: FilterTableViewController) = {
            return FilterTableViewController.fromStoryboard(delegate: self)
    }()
    
    fileprivate func stopObserving() {
        listener?.remove()
    }
    
    private var listener: ListenerRegistration?
    
    fileprivate func observeQuery() {
        guard let query = query else { return }
        stopObserving()
        
        let tabBar = tabBarController as! TabBarController
        
        listener = query.addSnapshotListener { [unowned self] (documents, error) in
            guard let snapshot = documents else {
                print("Error fetching snapshot results: \(error!)")
                return
            }
            
            let models = snapshot.documents.map { (document) -> Location in
                if let model = Location(dictionary: document.data(), id: document.documentID) {
                    return model
                } else {
                    // Don't use fatalError here in a real app.
                    fatalError("Unable to initialize type \(Location.self) with dictionary \(document.data())")
                }
            }
            self.locations = models
            self.documents = snapshot.documents
            
            tabBar.locations = self.locations
            
            if self.documents.count > 0 {
               // TODO
            } else {
                // TODO
            }
            
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterButton.applyDesign()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.masksToBounds = true
        tableView.layer.borderColor = UIColor.lightGray.cgColor
            //UIColor( red: 153/255, green: 153/255, blue:0/255, alpha: 1.0 ).cgColor
        tableView.layer.borderWidth = 0.5
        //self.tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: "locationCell")
        
        query = baseQuery()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopObserving()
    }
    
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeQuery()
    }
    
    // Build out the table of locations
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationTableViewCell
 
        print("Cell: ", cell.locationLabel)
        let location = locations[indexPath.row]
        
        cell.locationLabel!.text = location.location
        
        SDWebImageManager.shared().delegate = self
        SDWebImageManager.shared().loadImage(with: URL(string: location.imageURL), options: [], progress: nil) { (image, data, error, cacheType, finished, url) in
            // Do something
            cell.locationImage.image = image
        }
        
        // Add journey distance and travel time
        // This needs to be set to users current location
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            let currentLocation = locManager.location
            
            // Set lat/longs for location and current position
            let currentLat = currentLocation!.coordinate.latitude
            let currentLong = currentLocation!.coordinate.longitude
            let locationLat = Double(location.latitude)
            let locationLong = Double(location.longitude)
            let locationName = location.location
            
            let origin = Waypoint(coordinate: CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong), name: "Your Location")
            let destination = Waypoint(coordinate: CLLocationCoordinate2D(latitude: locationLat ?? currentLat, longitude: locationLong ?? currentLong), name: locationName)
            
            let options = NavigationRouteOptions(waypoints: [origin, destination])
            
            Directions.shared.calculate(options) { (waypoints, routes, error) in
                guard let route = routes?.first else { return }
                
                let locationDistanceMiles = lround(route.distance / 1609.344)
                let locationTravelTime = lround(route.expectedTravelTime / 60)
                
                cell.journeyTime.text = String(locationTravelTime) + " Mins"
                cell.journeyDistance.text = String(locationDistanceMiles) + " Miles"
            }
        }
        
        // Set promoted colour
        let red = CGFloat(89/255.0)
        let green = CGFloat(201/255.0)
        let blue = CGFloat(165/255.0)
        
        // Style locations with marketing - promoted
        if (location.location == "Porthcurno Beach") ||
            (location.location == "St Michael’s Mount") ||
            (location.location == "Trebah Garden") {
            cell.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 0.2)
        } else {
            cell.backgroundColor = .white
        }

        return cell
    }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //imageURL = imageURL(from: locations[indexPath.row].imageURL)
        location = [locations[indexPath.row]]
    
        performSegue(withIdentifier: "toLocationDetail", sender: self)
    }
    
    // Resize image from url to be consistent with UIImageView
    func imageManager(_ imageManager: SDWebImageManager, transformDownloadedImage image: UIImage?, with imageURL: URL?) -> UIImage? {
        guard let image = image, let imageURL = imageURL else {
            return nil
        }
        if (imageURL.lastPathComponent == "large" && (image.size.width > 1000 || image.size.width > 1000)) {
            let targetSize = CGSize(width: 82.5, height: 82.5)
            UIGraphicsBeginImageContextWithOptions(targetSize, !SDCGImageRefContainsAlpha(image.cgImage), image.scale)
            image.draw(in: CGRect(origin: .zero, size: targetSize))
            
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return scaledImage
        } else {
            return image
        }
    }
}

extension HomeViewController: FilterTableViewControllerDelegate {
    
    func query(beach: Bool?, cafe: Bool?, gardens: Bool?, historical: Bool?, trails: Bool?) -> Query {
        var filtered = baseQuery()
        
        
        // Applying filtering queries
        if beach == true {
            filtered = filtered.whereField("beach", isEqualTo: true)
        }
        
        if cafe == true {
            filtered = filtered.whereField("cafe", isEqualTo: true)
        }
        
        if gardens == true {
            filtered = filtered.whereField("gardens", isEqualTo: true)
        }
        
        if historical == true {
            filtered = filtered.whereField("historical", isEqualTo: true)
        }
        
        if trails == true {
            filtered = filtered.whereField("trails", isEqualTo: true)
        }
        
        return filtered
    }
    
    func controller(_ controller: FilterTableViewController,
                    beach: Bool?,
                    cafe: Bool?,
                    gardens: Bool?,
                    historical: Bool?,
                    trails: Bool?) {
        let filtered = query(beach: beach, cafe: cafe, gardens: gardens, historical: historical, trails: trails)

        self.query = filtered
        observeQuery()
    }
    
}

extension UIButton {
    func applyDesignToFilterButton() {
        
        let redUIColor = CGFloat(89/255.0)
        let greenUIColor = CGFloat(201/255.0)
        let blueUIColor = CGFloat(165/255.0)
        
        self.backgroundColor = UIColor(red: redUIColor, green: greenUIColor, blue: blueUIColor, alpha: 1.0)
        self.layer.cornerRadius = 5
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}



