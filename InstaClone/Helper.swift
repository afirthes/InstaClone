//
//  Helper.swift
//  InstaClone
//
//  Created by Afir Thes on 16.09.2021.
//

import UIKit
import FirebaseAuth

class Helper {
    
    class func errorAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { ACTION in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        return alert
    }
    
    class func logout() {
        
        do {
            try Auth.auth().signOut()
            
            let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let loginVC = loginStoryboard.instantiateViewController(identifier: "Login") as! LoginViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            guard let window = appDelegate.window else { return }
            window.rootViewController = loginVC
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        
    }
    
    class func login() {
        
        
    }
    
}
