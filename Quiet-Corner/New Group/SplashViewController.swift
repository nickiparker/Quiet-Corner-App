//
//  SplashViewController.swift
//  Quiet-Corner
//
//  Created by NICKI PARKER on 17/02/2019.
//  Copyright © 2019 Nickiparker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseUI

class SplashViewController: UIViewController {
   // @IBOutlet weak var doBtnLogIn: UIButton!
    
    fileprivate(set) var auth: Auth?
    fileprivate(set) var authUI: FUIAuth?
    fileprivate(set) var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Use to display the UserDefaults - debugging
        //  for (key, value) in  UserDefaults.standard.dictionaryRepresentation() {
        //            print("\(key) = \(value) \n")
        //  }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isLoggedIn() {
            // assume user is logged in
            performSegue(withIdentifier: "toHomeTableView", sender: self)
        } else {
            // nothing
        }
    }
    
    fileprivate func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }

    @IBAction func doBtnLogIn(_ sender: Any) {
        
        // Get the default auth UI object
        let authUI = FUIAuth.defaultAuthUI()
        
        guard authUI != nil else {
            // log error
            return
        }
        
        // Set ourselves as the delegate
        authUI?.delegate = self
        authUI?.providers = [FUIEmailAuth(), FUIGoogleAuth()]
        
        // Get a reference to the auth UI view controller
        let authVC = authUI?.authViewController()
        
        // Show it
        self.present(authVC!, animated: true, completion: nil)
    }
    
    @IBAction func unwindToSplashView(segue:UIStoryboardSegue) { }
    
}
    
extension SplashViewController: FUIAuthDelegate {
    // Implement the required protocol method for FIRAuthUIDelegate
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        // Check for error
        guard error == nil else {
            return
        }
        
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.synchronize()
        
        performSegue(withIdentifier: "toHomeTableView", sender: self)
    }
    
}
