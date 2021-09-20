//
//  UserData.swift
//  InstagramApp
//
//

import Foundation
import FirebaseDatabase
import FirebaseCore
import FirebaseStorage
import FirebaseAuth

import UIKit

struct User {
    
    var name: String
    
    var profileImage: UIImage
    
}

class UsersModel {
    
    var users: [User] = [User]()
    
    init() {
        
        let user1 = User(name: "John Carmack", profileImage: UIImage(named: "user1")!)
        
        users.append(user1)
        
        let user2 = User(name: "Bjarne Stroustrup", profileImage: UIImage(named: "user2")!)
        
        users.append(user2)
        
    }
    
    
}



class UserModel {
    
    static var personalFeed: DatabaseReference {
        get {
            return Database.database(url: "https://instaclone-b0cdb-default-rtdb.europe-west1.firebasedatabase.app")
                .reference().child("user_posts")
        }
    }
    
    static var collection: DatabaseReference {
        get {
            return Database.database(url: "https://instaclone-b0cdb-default-rtdb.europe-west1.firebasedatabase.app")
                .reference()
                .child("users")
        }
    }
    
    var username: String = ""
    var bio: String = ""
    var profileImage: URL?
    var userId: String
    
    init?(_ snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any] else { return nil }
        self.username = value["username"] as? String ?? "<not found>"
        self.bio = value["bio"] as? String ?? "<not found>"
        if let profileImage = value["profile_image"] as? String {
            self.profileImage = URL(string: profileImage)
        }
        self.userId = snapshot.key
    }
    
}
