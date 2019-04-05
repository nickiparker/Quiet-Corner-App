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
    
//    fileprivate(set) var auth: Auth?
//    fileprivate(set) var authUI: FUIAuth?
//    fileprivate(set) var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Re-trigger auth (for testing)
        //        do {
        //            try Auth.auth().signOut()
        //            }
        //             catch {}
        //        }
        
       
//        // Show homepage if User is currently signed in
//        if Auth.auth().currentUser != nil {
//            print("Current User: ")
//            print(Auth.auth().currentUser)
//            performSegue(withIdentifier: "goHome", sender: self)
//        } else {
//            print("Current User: ")
//            print(Auth.auth().currentUser)
//        }
    }

   
    
    //    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
    //        if error == nil {
    //            btnLogIn.setTitle("Logout", for: .normal)
    //        }
    //    }
    //    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
    //        if error == nil {
    //            btnLogIn.setTitle("Log Out", for: .normal)
    //        }
    //    }
    
    
    @IBAction func doBtnLogIn(_ sender: Any) {
        
        // Get the default auth UI object
        //let auth = Auth.auth()
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
        
        
//        self.authStateListenerHandle = self.auth?.addStateDidChangeListener{ (auth, user) in
//            guard user != nil else{
//                self.loginAction(sender: self)
//                return
//            }
//        }
//
        // Show it
        self.present(authVC!, animated: true, completion: nil)
    }
    
}
    
extension SplashViewController: FUIAuthDelegate {
    // Implement the required protocol method for FIRAuthUIDelegate
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        // Check for error
        guard error == nil else {
            return
        }
        
        performSegue(withIdentifier: "goHome", sender: self)
    }
    
}
    
//   Currently Redundant (Changed log in function)
//    @IBAction func doBtnLogOut(_ sender: Any) {
//        print(self.auth?.currentUser);
//        if self.auth?.currentUser != nil {
//            do {
//                try self.auth?.signOut()
//                doBtnLogOut.isHidden = true
//            }
//            catch {}
//        }
//    }
    

