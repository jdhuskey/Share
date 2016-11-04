//
//  FeedVC.swift
//  Share
//
//  Created by Jeffrey D Huskey on 11/4/16.
//  Copyright © 2016 FavoredFruit. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase


class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! FIRAuth.auth()?.signOut()
        dismiss(animated: true) {
            
            
            
        }
        //performSegue(withIdentifier: "goToSignIn", sender: nil)
        
    }
    
    
}
