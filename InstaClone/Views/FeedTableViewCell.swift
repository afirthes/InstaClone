//
//  FeedTableViewCell.swift
//  InstaClone
//
//  Created by Afir Thes on 14.09.2021.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameTitleButton: UIButton!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var postCommentLabel: UILabel!
    @IBOutlet weak var commentCountButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likesButton: UIButton!
    
    
    var postModel: PostModel?
    
    var likesModel: LikesModel?
    
    var currentUser: UserModel?
    
    var post: Post?
    weak var feedDelegate: FeedDataDelegate?
    weak var profileDelegate: ProfileDelegate?
    
    
    var userRef: DatabaseReference? {
        willSet {
            resetUser()
        }
        didSet {
            userRef?.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
                guard let strongSelf = self else { return }
                
                if let user = UserModel(snapshot) {
                    strongSelf.currentUser = user
                    
                    DispatchQueue.main.async {
                        strongSelf.setup(user: user)
                    }
                    
                }
            })
        }
    }
    
    var likesRef: DatabaseReference? {
        willSet {
            resetLikes()
        }
        
        didSet {
            likesRef?.observeSingleEvent(of: .value, with: { [weak self] snapshot in
                guard let strongSelf = self else { return }
                let likesModel = LikesModel(snapshot)
                strongSelf.likesModel = likesModel
                
                DispatchQueue.main.async {
                    strongSelf.setup(likes: likesModel)
                }
                
            })
        }
    }
    
    func setup(likes: LikesModel?) {
        guard let likes = likes else { return }
        
        likesCountLabel.text = "\(likes.likeCount)"
        likesButton.isSelected = likes.postDidLike
        
    }
    
    func resetLikes() {
        likesButton.isSelected = false
        likesCountLabel.text = "0 likes"
    }
    
    func resetUser() {
        userNameTitleButton.setTitle("---", for: .normal)
        profileImage.image = nil
    }
    
    func setup(user: UserModel) {
        userNameTitleButton.setTitle(user.username, for: .normal)
        if let userProfileImage = user.profileImage {
            profileImage.sd_cancelCurrentImageLoad()
            profileImage.sd_setImage(with: userProfileImage, completed: nil)
        }
    }
    
    weak var deletePostDelegate: PostDeleDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.layer.masksToBounds = true
        selectionStyle = .none
        
        likesButton.setImage(UIImage(named: "did_like"), for: .selected)
        likesButton.setImage(UIImage(named: "like_icon"), for: .normal)
    }
    
    @IBAction func likesButtonDidTouch(_ sender: Any) {
        
        guard let postModel = postModel else { return }
        guard let likesModel = likesModel else { return }
    
        likesModel.postDidLike = !likesModel.postDidLike
        
        likesButton.isSelected = likesModel.postDidLike
        
        if likesModel.postDidLike {
            LikesModel.postLiked(postModel.key)
            likesModel.likeCount += 1
            
        } else {
            LikesModel.postUnLiked(postModel.key)
            if likesModel.likeCount > 0 {
                likesModel.likeCount -= 1
            }
            
        }
        likesCountLabel.text = "\(likesModel.likeCount) likes"
    
    }
    
    @IBAction func commentButtonDidTouch(_ sender: Any) {
        guard let postModel = postModel else { return }
        guard let currentUser = currentUser else { return }
        guard let likesModel = likesModel else { return }
        
        self.feedDelegate?.commentsDidTouch(post: postModel, likesModel: likesModel, userModel: currentUser)
    }
    
    
    @IBAction func viewCommentsButtonDidTouch(_ sender: Any) {
        guard let postModel = postModel else { return }
        guard let currentUser = currentUser else { return }
        guard let likesModel = likesModel else { return }
        
        self.feedDelegate?.commentsDidTouch(post: postModel, likesModel: likesModel, userModel: currentUser)
    }
    
    @IBAction func deletePostDidTouch(_ sender: Any) {
        
        guard let postModel = postModel else { return }
        let userPostId = postModel.userId
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        if userPostId == currentUserId {
            deletePostDelegate?.confirmDelete(postId: postModel.key)
        }
        
    }
    
    @IBAction func userNameDidTouch(_ sender: Any) {
        guard let userId = currentUser?.userId else { return }
        profileDelegate?.userNameDidTouch(userId: userId)
    }
    
}
