//
//  UITableViewController.swift
//  Quiet-Corner
//
//  Created by NICKI PARKER on 03/04/2019.
//  Copyright © 2019 Nickiparker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseUI

class FilterTableViewController: UITableViewController {
    
    var filters = Filters(dictionary: ["String" : Bool.self])

    @IBAction func goToMapButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "goToMapSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
    }
    
    // Filter toggles
    @IBAction func beachSwitch(_ sender: UISwitch) {
        if (sender.isOn) {
            filters.beach = true
           print(filters)
        } else {
           filters.beach = false
            print(filters)
        }
    }
    
    @IBAction func historicalSwitch(_ sender: UISwitch) {
        if (sender.isOn) {
            filters.historical = true
            print(filters)
        } else {
            filters.historical = false
            print(filters)
        }
    }
    
    @IBAction func gardensSwitch(_ sender: UISwitch) {
        if (sender.isOn) {
            filters.gardens = true
            print(filters)
        } else {
            filters.gardens = false
            print(filters)
        }
    }
    
    @IBAction func trailsSwitch(_ sender: UISwitch) {
        if (sender.isOn) {
            filters.trails = true
            print(filters)
        } else {
            filters.trails = false
            print(filters)
        }
    }
    
    @IBAction func cafeSwitch(_ sender: UISwitch) {
        if (sender.isOn) {
            filters.cafe = true
            print(filters)
        } else {
            filters.cafe = false
            print(filters)
        }
    }
}
