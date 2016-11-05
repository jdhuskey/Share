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


class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
        
            //print(snapshot.value as Any)
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    
                    print("SNAP: \(snap)")
                    
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDictionary)
                        
                        self.posts.append(post)
                        
                    }
                    
                }
                
            }
        
            self.tableView.reloadData()
            
        })
    
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        print("JEFF: \(post.caption)")
        
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        //return UITableViewCell()
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! FIRAuth.auth()?.signOut()
        dismiss(animated: true)
        //performSegue(withIdentifier: "goToSignIn", sender: nil) // This leaves views in the stack using memory if the user goes back and forth, but "dismiss" (above) will not, and at the end of lecture 149, there was not yet any reason to use performSegue instead of dismiss. I'm surprised this isn't covered/considered
        
    }
    
    
}
