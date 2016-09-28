//
//  ViewController.swift
//  devslopes-social
//
//  Created by margibs on 26/09/2016.
//  Copyright © 2016 margibs. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookBtnTapped(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                
                print("JESS: unable to authenticate with Facebook - \(error)")
                
            } else if result?.isCancelled == true {
                
                print("JESS: User cancelled Facebook authentication")
                
            } else {
                
                print("JESS: Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                self.firebaseAuth(credential)
                
            }//END if error
            
        }//END facebookLogin
        
    }//END func facebookBtnTapped
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            
            if error != nil {
                
              print("JESS: unable to authenticate with Firebase - \(error)")
                
            } else {
                
               print("JESS: Successfully authenticated with Firebase")
                
            }
            
        })
        
    }//END func firebaseAuth
}

