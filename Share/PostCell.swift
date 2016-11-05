//
//  PostCell.swift
//  Share
//
//  Created by Jeffrey D Huskey on 11/5/16.
//  Copyright © 2016 FavoredFruit. All rights reserved.
//

import UIKit

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

    func configureCell(post: Post) {
        
        self.post = post
        self.caption.text = post.caption
        self.likesLabel.text = "\(post.likes)"
        
    }
    
}
