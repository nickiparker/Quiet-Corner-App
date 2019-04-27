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

var location: [Location] = []

class HomeTableViewController: UITableViewController {
    
    // locations firebase
    let db = Firestore.firestore()
    private var documents: [DocumentSnapshot] = []
    public var locations: [Location] = []
    
    // To help get users current long/lat coordinates
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!

    @IBAction func didTapFilterButton(_ sender: UIBarButtonItem) {
        present(filter.navigationController, animated: true, completion: nil)
    }
 
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
        
        listener = query.addSnapshotListener { [unowned self] (documents, error) in
            guard let snapshot = documents else {
                print("Error fetching snapshot results: \(error!)")
                return
            }
            
            print(snapshot.documents[0].data())
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationTableViewCell
    
        let location = locations[indexPath.row]
        
        cell.locationLabel!.text = location.location
        
        // Add journey distance and travel time
        // This needs to be set to users current location
        locManager.requestWhenInUseAuthorization()
        
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


        return cell
    }
    
   override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //imageURL = imageURL(from: locations[indexPath.row].imageURL)
        location = [locations[indexPath.row]]
    
        performSegue(withIdentifier: "toLocationDetail", sender: self)
    }
}

extension HomeTableViewController: FilterTableViewControllerDelegate {
    
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



