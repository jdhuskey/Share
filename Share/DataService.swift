//
//  DataService.swift
//  Share
//
//  Created by Jeffrey D Huskey on 11/5/16.
//  Copyright © 2016 FavoredFruit. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {
    
    static let ds = DataService()
    
    // DB References
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: FIRDatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!) // !!!!!! WE REALLY SHOULD HANDLE WHAT WOULD HAPPEN IF THERE IS NO uid AVAILABLE INSTEAD OF JUST FORCE UNWRAPPING THIS CONSTANT. I DON'T THINK IT'S GOING TO HAPPEN WHERE WE WOULDN'T HAVE A uid, BUT IT'S NOT GOOD TO ALLOW A CRASH-POINT LIKE THIS.
        return user
    }
    
    // STORAGE References
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-images")
    private var _REF_PROFILE_IMAGES = STORAGE_BASE.child("profile-images")
    
    var REF_POST_IMAGES: FIRStorageReference {
        return _REF_POST_IMAGES
    }
    
    var REF_PROFILE_IMAGES: FIRStorageReference {
        return _REF_PROFILE_IMAGES
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        
        REF_USERS.child(uid).updateChildValues(userData)
        
    }
    
}
