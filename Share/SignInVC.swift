//
//  SignInVC.swift
//  Share
//
//  Created by Jeffrey D Huskey on 11/3/16.
//  Copyright © 2016 FavoredFruit. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper


class SignInVC: UIViewController {

    @IBOutlet weak var emailField: CustomTextField!
    @IBOutlet weak var passwordField: CustomTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            
            print("JEFF: ID found in Keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
            
        }

    }

    @IBAction func facebookButtonTapped(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                
                print("JEFF: Unable to authenticate with Facebook - \(error)")
                
            } else if result?.isCancelled == true {
                
                print("JEFF: User cancelled Facebook authentication.")
                
            } else {
                
                print("JEFF: Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
                
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                
                print("JEFF: Unable to authenticate with Firebase - \(error)")
                
            } else {
                
                print("JEFF: Successfully authenticated with Firebase")
                if let user = user {
                    
                    let userData = ["provider" : credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                    
                }
            }
        })
    }

    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let password = passwordField.text {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                
                if error == nil {
                    
                    print("JEFF: Email user successfully authenticated with Firebase")
                    if let user = user {
                        
                        let userData = ["provider" : user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                        
                    }
                    
                } else {
                    
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        
                        if error != nil {
                            
                            print("JEFF: Email user unable to authenticate with Firebase - \(error)")
                            
                        } else {
                            
                            print("JEFF: Email user successfully created and authenticated with Firebase")
                            if let user = user {
                                
                                let userData = ["provider" : user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                                
                            }
                            
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        let saveToKeychainSuccessful = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        
        print("JEFF: Data saved to keychain - \(saveToKeychainSuccessful)")
        
        performSegue(withIdentifier: "goToFeed", sender: nil)
        
    }
}

