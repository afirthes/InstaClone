//
//  Helper.swift
//  InstaClone
//
//  Created by Afir Thes on 16.09.2021.
//

import UIKit

class Helper {
    
    func errorAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { ACTION in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        return alert
    }
    
}
