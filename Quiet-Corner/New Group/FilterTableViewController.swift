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
    
    weak var delegate: FilterTableViewControllerDelegate?
    
    static func fromStoryboard(delegate: FilterTableViewControllerDelegate? = nil) ->
        (navigationController: UINavigationController, filterController: FilterTableViewController) {
            let navController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "FilterTableViewController")
                as! UINavigationController
            let controller = navController.viewControllers[0] as! FilterTableViewController
            controller.delegate = delegate
            return (navigationController: navController, filterController: controller)
     }
    
    var filters = Filters(dictionary: ["String" : Bool.self])

    @IBAction func applyFilters(_ sender: UIBarButtonItem) {
        delegate?.controller(self, beach: beachSwitch.isOn, cafe: cafeSwitch.isOn,
                             gardens: gardensSwitch.isOn, historical: historicalSwitch.isOn, trails: trailsSwitch.isOn)
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        // Creates an invisible footer view to remove unwanted lines below list
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    // Filter toggles
    @IBOutlet var beachSwitch: UISwitch!
    
    @IBOutlet var historicalSwitch: UISwitch!
    
    @IBOutlet var gardensSwitch: UISwitch!
    
    @IBOutlet var trailsSwitch: UISwitch!
    
    @IBOutlet var cafeSwitch: UISwitch!
}

protocol FilterTableViewControllerDelegate: NSObjectProtocol {
    
    func controller(_ controller: FilterTableViewController,
                    beach: Bool?, cafe: Bool?, gardens: Bool?,
                    historical: Bool?, trails: Bool?)
}
