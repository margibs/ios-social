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
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.defaultKeychainWrapper.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
            print("hello world222")
        }
        
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
                
                if let user = user {
                    
                    let userData = ["provider" : credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                    
                }//END if let user
                
            }//END if error
            
        })//END FIRAuth
        
    }//END func firebaseAuth
    
    @IBAction func signInTapped(_ sender: AnyObject) {
        
        if let email = emailField.text, let pwd = pwdField.text {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                
                if error == nil {
                    print("JESS: User authenticated with Firebase")
                    
                    if let user = user {
                        let userData = ["provider" : user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                        
                    }//END if let user
                    
                } else {
                    
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        
                        if error != nil {
                           print("JESS: Unable to authenticate with Firebase using email")
                        } else {
                            print("JESS: Successfully authenticated with Firebase")
                            
                            if let user = user {
                                let userData = ["provider" : user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                                
                            }//END if let user
                        }
                        
                    })
                    
                }//END if error
                
            })//END FIRAuth
            
        }//END if let email
        
    }//END IBAction
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        let keychainResult = KeychainWrapper.defaultKeychainWrapper.set(id, forKey: KEY_UID)
        print("JESS: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
}//END CLASS

