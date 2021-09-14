//
//  StoryCollectionViewCell.swift
//  InstaClone
//
//  Created by Afir Thes on 13.09.2021.
//

import UIKit

class StoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var storyImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        storyImage.layer.cornerRadius = storyImage.frame.width / 2
        storyImage.layer.masksToBounds = true
        
        storyImage.layer.borderColor = UIColor.white.cgColor
        storyImage.layer.borderWidth = 3
        
        
        
    }

}
