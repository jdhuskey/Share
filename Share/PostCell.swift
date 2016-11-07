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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(post: Post, image: UIImage? = nil) {
        
        // Setting TEXT values in Post
        self.post = post
        self.caption.text = post.caption
        self.likesLabel.text = "\(post.likes)"
        
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
        
    }
    
}
