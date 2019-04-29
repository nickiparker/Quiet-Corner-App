//
//  ProfileViewController.swift
//  Quiet-Corner
//
//  Created by NICKI PARKER on 18/04/2019.
//  Copyright © 2019 Nickiparker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutButton.applyDesign()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserProfile()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       // ...
    }
    
    func getUserProfile(){
        if Auth.auth().currentUser != nil {
            guard let userEmail = Auth.auth().currentUser?.email else { print("returning"); return }
            self.emailLabel.text = userEmail
        }
    }

    @IBAction func logOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("Error: ", error)
        }
        
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.synchronize()
        
        performSegue(withIdentifier: "unwindToSplashView", sender: self)
    }
    
}
