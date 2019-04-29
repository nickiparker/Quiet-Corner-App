//
//  TabBarControllerViewController.swift
//  Quiet-Corner
//
//  Created by NICKI PARKER on 28/04/2019.
//  Copyright © 2019 Nickiparker. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    var locations: [Location] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make unselected tabbar image white
        tabBar.unselectedItemTintColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        
        // Do any additional setup after loading the view.
    }
    

    

}
