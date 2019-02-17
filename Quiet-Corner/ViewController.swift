//
//  ViewController.swift
//  Quiet-Corner
//
//  Created by NICKI PARKER on 17/02/2019.
//  Copyright © 2019 Nickiparker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseUI

class ViewController: UIViewController, FUIAuthDelegate {
    @IBOutlet weak var doBtnLogOut: UIButton!
    
    fileprivate(set) var auth: Auth?
    fileprivate(set) var authUI: FUIAuth?
    fileprivate(set) var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Re-trigger auth (for testing)
        //        do {
        //            try Auth.auth().signOut()
        //            }
        //             catch {}
        //        }
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // Authentication via FirebaseUI
        self.auth = Auth.auth()
        self.authUI = FUIAuth.defaultAuthUI()
        self.authUI?.delegate = self
        self.authUI?.providers = [FUIEmailAuth(), FUIGoogleAuth()]
        
        
        self.authStateListenerHandle = self.auth?.addStateDidChangeListener{ (auth, user) in
            guard user != nil else{
                self.loginAction(sender: self)
                return
            }
        }
        
        //        let authUI = FUIAuth.defaultAuthUI()
        //        authUI?.delegate = self
        //        let providers : [FUIAuthProvider] = [FUIEmailAuth(), FUIGoogleAuth()]
        //        self.authUI?.providers = providers
        //
        //        // Show FirebaseUI Authentication if User is not currently signed in
        //        if Auth.auth().currentUser == nil {
        //            if let authVC = authUI?.authViewController() {
        //                present(authVC, animated: true, completion: nil)
        //            }
        //        } else {
        //            do {
        //                try Auth.auth().signOut()
        //                self.btnLogIn.setTitle("Log In", for: .normal)
        //            }
        //            catch {}
        //        }
    }
    
    // Implement the required protocol method for FIRAuthUIDelegate
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        guard let authError = error else { return }
        
        let errorCode = UInt((authError as NSError).code)
        
        switch errorCode {
        case FUIAuthErrorCode.userCancelledSignIn.rawValue:
            print("User cancelled sign-in");
            break
            
        default:
            let detailedError = (authError as NSError).userInfo[NSUnderlyingErrorKey] ?? authError
            print("Login error: \((detailedError as! NSError).localizedDescription)");
        }
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
    
    @IBAction func loginAction(sender: AnyObject) {
        let authVC = authUI?.authViewController()
        self.present(authVC!, animated: true, completion: nil)
        //Make button2 Visible
        doBtnLogOut.isHidden = false
    }
    
    @IBAction func doBtnLogOut(_ sender: Any) {
        if self.auth?.currentUser != nil {
            do {
                try self.auth?.signOut()
                doBtnLogOut.isHidden = true
            }
            catch {}
        }
    }
    
}
