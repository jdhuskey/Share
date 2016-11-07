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


class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImage: RoundImageView!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
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
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            cell.configureCell(post: post)
            return cell
            
        } else {
        
            return PostCell()
            
        }
        
        //return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        //return UITableViewCell()
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            addImage.image = image
            
        } else {
            
            print("JEFF: A valid image wasn't selected.")
            
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! FIRAuth.auth()?.signOut()
        dismiss(animated: true)
        //performSegue(withIdentifier: "goToSignIn", sender: nil) // This leaves views in the stack using memory if the user goes back and forth, but "dismiss" (above) will not, and at the end of lecture 149, there was not yet any reason to use performSegue instead of dismiss. I'm surprised this isn't covered/considered
        
    }
    
    
}
