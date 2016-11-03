//
//  CustomSignInButton.swift
//  Share
//
//  Created by Jeffrey D Huskey on 11/3/16.
//  Copyright © 2016 FavoredFruit. All rights reserved.
//

import UIKit

class CustomSignInButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // SHADOW
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        // CORNER RADIUS
        layer.cornerRadius = 2.0
        
    }
    
}
