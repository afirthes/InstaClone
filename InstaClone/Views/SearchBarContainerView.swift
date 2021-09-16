//
//  SearchBarContainerView.swift
//  InstaClone
//
//  Created by Afir Thes on 15.09.2021.
//

import UIKit

class SearchBarContainerView: UIView {

   
    let searchBar: UISearchBar
    
    init(customSearchBar: UISearchBar) {
        searchBar = customSearchBar
        
        super.init(frame: CGRect.zero)
        
        addSubview(searchBar)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience override init(frame: CGRect) {
        self.init(customSearchBar: UISearchBar())
        self.frame = frame
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        searchBar.frame = bounds
    }
    
}
