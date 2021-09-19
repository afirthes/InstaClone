//
//  PostTableViewCell.swift
//  InstaClone
//
//  Created by Afir Thes on 19.09.2021.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameTitleButton: UIButton!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var postCommentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likesButton: UIButton!
    
    var post: Post?
    
    var postModel: PostModel?
    
    var likesModel: LikesModel? {
        didSet {
            guard let likesModel = likesModel else { return }
            setup(likes: likesModel)
        }
    }
    
    var currentUserModel: UserModel? {
        didSet {
            guard let currentUserModel = currentUserModel else { return }
            setup(user: currentUserModel)
        }
    }
    
    weak var profileDelegate: ProfileDelegate?
    
    weak var feedDelegate: FeedDataDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.layer.masksToBounds = true
        selectionStyle = UITableViewCell.SelectionStyle.none
        likesButton.setImage(UIImage(named: "did_like"), for: .selected)
        likesButton.setImage(UIImage(named: "like_icon"), for: .normal)
    }
    
    func setup(user: UserModel) {
        userNameTitleButton.setTitle(user.username, for: .normal)
        if let userProfileImage = user.profileImage {
            profileImage.sd_cancelCurrentImageLoad()
            profileImage.sd_setImage(with: userProfileImage, completed: nil)
        }
    }
    
    func setup(likes: LikesModel?) {
        guard let likes = likes else { return }
        
        likesCountLabel.text = "\(likes.likeCount)"
        likesButton.isSelected = likes.postDidLike
    }
    
    @IBAction func userNameButtonDidTouch(_ sender: Any) {
        profileDelegate?.userNameDidTouch()
    }
    
    @IBAction func likeButtonDidTouch(_ sender: Any) {
        
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
    
    
}
