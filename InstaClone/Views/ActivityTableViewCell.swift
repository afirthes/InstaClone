//
//  ActivityTableViewCell.swift
//  InstaClone
//
//  Created by Afir Thes on 16.09.2021.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var detailsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImage.layer.masksToBounds = true
        selectionStyle = UITableViewCell.SelectionStyle.none
    }

    override func layoutSubviews() {
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
    }
    
}
