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

    @IBAction func goToMapButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "goToMapSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
    }
}
