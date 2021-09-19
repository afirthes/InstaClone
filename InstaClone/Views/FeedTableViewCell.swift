//
//  FeedTableViewCell.swift
//  InstaClone
//
//  Created by Afir Thes on 14.09.2021.
//

import UIKit
import Firebase
import FirebaseDatabase

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameTitleButton: UIButton!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var postCommentLabel: UILabel!
    @IBOutlet weak var commentCountButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    var currentUser: UserModel?
    var userRef: DatabaseReference? {
        willSet {
            resetUser()
        }
        didSet {
            userRef?.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
                guard let strongSelf = self else { return }
                
                if let user = UserModel(snapshot) {
                    strongSelf.currentUser = user
                    strongSelf.setup(user: user)
                }
            })
        }
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.layer.masksToBounds = true
        selectionStyle = .none
    }
    
    

    
}
