//
//  HomeTableViewController.swift
//  Quiet-Corner
//
//  Created by NICKI PARKER on 08/04/2019.
//  Copyright © 2019 Nickiparker. All rights reserved.
//

import UIKit
import Firebase

class HomeTableViewController: UITableViewController {

    // locations firebase
    let db = Firestore.firestore()
    private var documents: [DocumentSnapshot] = []
    public var locations: [Location] = []
    private var listener : ListenerRegistration!
    
   // Future implementation for user specific functionality
   // var user: User!
   // var userCountBarButtonItem: UIBarButtonItem!

    @IBAction func toFilterListButton(_ sender: UIBarButtonItem) {
    }
 
    // Firebase global setter to constrain firebase query to max 50
    fileprivate func baseQuery() -> Query {
        return Firestore.firestore().collection("locations").limit(to: 50)
    }
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.query = baseQuery() // firebase db query
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.listener.remove()
    }
    
     override func viewWillAppear(_ animated: Bool) {
        self.listener =  query?.addSnapshotListener { (documents, error) in
            guard let snapshot = documents else {
                print("Error fetching documents results: \(error!)")
                return
            }
            
            let results = snapshot.documents.map { (document) -> Location in
                if let location = Location(dictionary: document.data(), id: document.documentID) {
                    return location
                } else {
                    fatalError("Unable to initialize type \(Location.self) with dictionary \(document.data())")
                }
            }
            
            print("Locations: \n", results)
            print("Documents: \n", snapshot.documents)
            self.locations = results
            self.documents = snapshot.documents
            self.tableView.reloadData()
            
        }
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
        cell.descriptionLabel!.text = location.description

        return cell
    }
}
