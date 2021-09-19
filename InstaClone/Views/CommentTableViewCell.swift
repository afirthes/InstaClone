//
//  CommentTableViewCell.swift
//  InstaClone
//
//  Created by Afir Thes on 19.09.2021.
//

import UIKit

import FirebaseDatabase

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    var commentIndex: Int?
    
    var currentUserModel: UserModel?
    
    var userRef: DatabaseReference? {
        willSet {
            userNameLabel.text = "---"
        }
        
        didSet {
            userRef?.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
                guard let strongSelf = self else { return }
                if let user = UserModel(snapshot) {
                    strongSelf.currentUserModel = user
                    DispatchQueue.main.async {
                        strongSelf.userNameLabel.text = user.username
                    }
                }
            })
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //commentLabel.delegate = self
        
        selectionStyle = .none
        
    }
    
}


