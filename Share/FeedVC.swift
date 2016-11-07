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
    @IBOutlet weak var captionField: CustomTextField!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    

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
            
            if let image = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                
                cell.configureCell(post: post, image: image)
                return cell
                
            } else {
                
                cell.configureCell(post: post)
                return cell

            }
            
        } else {
        
            return PostCell()
            
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            addImage.image = image
            imageSelected = true
            
        } else {
            
            imageSelected = false
            print("JEFF: A valid image wasn't selected.")
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func postTapped(_ sender: Any) {
        
        guard let caption = captionField.text, caption != "" else {
            
            print("JEFF: Caption must be entered.")
            return
            
        }
        
        guard let image = addImage.image, imageSelected == true else {
            
            print("JEFF: An image must be selected.")
            return
            
        }
        
        if let imageData = UIImageJPEGRepresentation(image, 0.2) {
            
            let imageUid = NSUUID().uuidString // This creates a unique string for the name of the image so that no images will have the same name.
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imageUid).put(imageData, metadata: metadata) { (metadata, error) in
                
                if error != nil {
                    
                    print("JEFF: Unable to upload image to Firebase storage.")
                    
                } else {
                    
                    print("JEFF: Successfully uploaded image to Firebase storage.")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! FIRAuth.auth()?.signOut()
        dismiss(animated: true)
        //performSegue(withIdentifier: "goToSignIn", sender: nil) // This leaves views in the stack using memory if the user goes back and forth, but "dismiss" (above) will not, and at the end of lecture 149, there was not yet any reason to use performSegue instead of dismiss. I'm surprised this isn't covered/considered
        
    }
    
    
}
