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
    
    @IBOutlet var loginButton: UIButton!
    
    
    fileprivate(set) var auth: Auth?
    fileprivate(set) var authUI: FUIAuth?
    fileprivate(set) var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.applyDesign()

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

extension UIButton {
    func applyDesign() {
        
        let redUIColor = CGFloat(89/255.0)
        let greenUIColor = CGFloat(201/255.0)
        let blueUIColor = CGFloat(165/255.0)

        self.backgroundColor = UIColor(red: redUIColor, green: greenUIColor, blue: blueUIColor, alpha: 1.0)
        self.layer.cornerRadius = 5
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
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
