//
//  PostCell.swift
//  Share
//
//  Created by Jeffrey D Huskey on 11/5/16.
//  Copyright © 2016 FavoredFruit. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likedImage: UIImageView!
    
    var post: Post!
    var likesReference: FIRDatabaseReference!

    override func awakeFromNib() {
        super.awakeFromNib()

        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likedImage.addGestureRecognizer(tap)
        likedImage.isUserInteractionEnabled = true
        
    }

    func configureCell(post: Post, image: UIImage? = nil) {
        
        // Setting TEXT values in Post
        self.post = post
        self.caption.text = post.caption
        self.likesLabel.text = "\(post.likes)"
        
        // Setup for setting Likes Image and Value
        likesReference = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        
        // Setting Images in Post
        if image != nil {
            
            self.postImage.image = image
            
        } else {
            
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                
                if error != nil {
                    
                    print("JEFF: Unable to download image from Firebase Storage.")
                    
                } else {
                    
                    print("JEFF: Image downloaded from Firebase Storage.")
                    if let imageData = data {
                        
                        if let image = UIImage(data: imageData) {
                            
                            self.postImage.image = image
                            FeedVC.imageCache.setObject(image, forKey: post.imageUrl as NSString)
                            
                        }
                        
                    }
                    
                }
                
            })
            
        }
        
        likesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let _ = snapshot.value as? NSNull {
                
                self.likedImage.image = UIImage(named: "empty-heart")
                
            } else {
                
                self.likedImage.image = UIImage(named: "filled-heart")
                
            }
        })
        
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        
        likesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let _ = snapshot.value as? NSNull {
                
                self.likedImage.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesReference.setValue(true)
                
            } else {
                
                self.likedImage.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesReference.removeValue()
                
            }
        })
        
    }
    
}
