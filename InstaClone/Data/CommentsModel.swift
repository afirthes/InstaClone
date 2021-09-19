//
//  CommentsModel.swift
//  InstaClone
//
//  Created by Afir Thes on 19.09.2021.
//

import Foundation
import FirebaseDatabase

class CommentsModel {
    
    static var collection: DatabaseReference {
        get {
            return Database.database().reference().child("comments")
        }
    }
    var userId: String
    var comment: String
    
    init?(_ snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String:Any] else { return nil }
        guard let userId = value["user"] as? String else {return nil}
        
        guard let  comment = value["comment"] as? String else {return nil}
        self.userId = userId
        self.comment = comment
        
    }
    
}
