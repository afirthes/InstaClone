//
//  FeedData.swift
//  InstagramApp
//
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import UIKit

struct Post {
    var postImage: UIImage
    var postComment: String
    var user: User
    var commentCount: Int
    var likesCount: Int
    var datePosted: String
}

struct Story {
    var post: Post
}

class Model {
    var postList: [Post] = [Post]()
    //var users: [User] = [User]()
    var storyList: [Story] = [Story]()

    init() {
        
        let user1 = User(name: "John Carmack", profileImage: UIImage(named: "user1")!)
        //users.append(user1)
        let user2 = User(name: "Bjarne Stroustrup", profileImage: UIImage(named: "user2")!)
        //users.append(user2)
        
        let post1 = Post(postImage: UIImage(named: "destination1")!, postComment: "This is a brilliant destination that I recently went to.", user: user1, commentCount: 5, likesCount: 10, datePosted: "3 Sept")
        
        postList.append(post1)
        
        let post2 = Post(postImage: UIImage(named: "destination2")!, postComment: "I am on the wide open road travelling to my new destination.", user: user2, commentCount: 14, likesCount: 12, datePosted: "4 Sept")
        
        postList.append(post2)
        
        postList.append(Post(postImage: UIImage(named: "destination5")!, postComment: "The long winding dusty road with the sun setting in the horizon.", user: user1, commentCount: 5, likesCount: 10, datePosted: "7 Sept"))
        
        postList.append(Post(postImage: UIImage(named: "destination4")!, postComment: "The long winding dusty road with the sun setting in the horizon.", user: user2, commentCount: 1, likesCount: 18, datePosted: "6 Sept"))
        
        postList.append(Post(postImage: UIImage(named: "destination5")!, postComment: "The long winding dusty road with the sun setting in the horizon.", user: user1, commentCount: 5, likesCount: 10, datePosted: "7 Sept"))
        
        postList.append(Post(postImage: UIImage(named: "destination5")!, postComment: "The long winding dusty road with the sun setting in the horizon.", user: user1, commentCount: 5, likesCount: 10, datePosted: "7 Sept"))
        
        
        postList.append(Post(postImage: UIImage(named: "destination3")!, postComment: "Can anyone beat this? This has to be the best sunset ever. I will be coming here again very soon!", user: user1, commentCount: 80, likesCount: 122, datePosted: "5 Sept"))
        
        postList.append(Post(postImage: UIImage(named: "destination5")!, postComment: "The long winding dusty road with the sun setting in the horizon.", user: user1, commentCount: 5, likesCount: 10, datePosted: "7 Sept"))
        
        postList.append(Post(postImage: UIImage(named: "destination5")!, postComment: "The long winding dusty road with the sun setting in the horizon.", user: user1, commentCount: 5, likesCount: 10, datePosted: "7 Sept"))
        
        postList.append(Post(postImage: UIImage(named: "destination5")!, postComment: "The long winding dusty road with the sun setting in the horizon.", user: user1, commentCount: 5, likesCount: 10, datePosted: "7 Sept"))
        
        postList.append(Post(postImage: UIImage(named: "destination5")!, postComment: "The long winding dusty road with the sun setting in the horizon.", user: user1, commentCount: 5, likesCount: 10, datePosted: "7 Sept"))
        
        postList.append(Post(postImage: UIImage(named: "destination5")!, postComment: "The long winding dusty road with the sun setting in the horizon.", user: user1, commentCount: 5, likesCount: 10, datePosted: "7 Sept"))
        
        storyList.append(Story(post: post1))
        
        storyList.append(Story(post: post2))
        
    }
    
    
}

class PostModel {
    static var collection: DatabaseReference {
        get {
            return Database
                .database(url: "https://instaclone-b0cdb-default-rtdb.europe-west1.firebasedatabase.app")
                .reference()
                .child("posts")
        }
    }
    
    static func newPost(userId: String, caption: String, imageDownloadURL: String) {
        let datePosted = Date().timeIntervalSince1970
        
        // request temporary key until we use it
        guard let key = PostModel.collection.childByAutoId().key else { return }
        
        let post:[String:Any] = [
            "user": userId,
            "image": imageDownloadURL,
            "caption": caption,
            "date": datePosted
        ]
        
        PostModel.collection.updateChildValues(["\(key)":post])
        let personalRef = UserModel.personalFeed
        personalRef.child(userId).updateChildValues(["\(key)":post])
    }
    
    var date: Date
    var userId: String
    var caption: String
    var imageURL: URL
    var key: String
    
    init?(_ snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any] else { return nil }
        guard let date = value["date"] as? Double else { return nil }
        guard let userId = value["user"] as? String else { return nil }
        guard let imagePath = value["image"] as? String else { return nil }
        guard let imageURL = URL(string: imagePath) else { return nil }
        guard let caption = value["caption"] as? String else { return nil }
        
        self.date = Date.init(timeIntervalSince1970: date)
        self.userId = userId
        self.caption = caption
        self.imageURL = imageURL
        self.key = snapshot.key
    }
}
