//
//  CommentTableViewCell.swift
//  InstaClone
//
//  Created by Afir Thes on 19.09.2021.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commentLabel: UILabel!
    
    var commentIndex: Int?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //commentLabel.delegate = self
        
        selectionStyle = .none
        
    }
    
}


