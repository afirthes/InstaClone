//
//  LikesModel.swift
//  InstaClone
//
//  Created by Afir Thes on 19.09.2021.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class LikesModel {
    
    static var collection: DatabaseReference {
        get {
            return Database.database(url: "https://instaclone-b0cdb-default-rtdb.europe-west1.firebasedatabase.app")
                .reference().child("likes")
        }
    }
    
    var postDidLike: Bool = false
    
    var likeCount: Int = 0
    
    init?(_ snapshot: DataSnapshot ) {
        guard let userId = Auth.auth().currentUser?.uid else { return nil }
        
        self.likeCount = snapshot.children.allObjects.count
    
        for item in snapshot.children {
            guard let snapshot = item as? DataSnapshot else { continue }
            if snapshot.key == userId {
                postDidLike = true
                break
            }
        }
    }
    
    static func postLiked(_ postKey: String) {
        if let userId = Auth.auth().currentUser?.uid {
            let likesRef = LikesModel.collection.child(postKey)
            likesRef.updateChildValues([userId: true])
        }
    }
    
    static func postUnLiked(_ postKey: String) {
        if let userId = Auth.auth().currentUser?.uid {
            let likesRef = LikesModel.collection.child(postKey).child(userId)
            likesRef.removeValue()
        }
    }
}
