//
//  AppDelegate.swift
//  InstaClone
//
//  Created by Afir Thes on 13.09.2021.
//

import UIKit
import Firebase

let tabBarDelegate = TabBarDelegate()

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        if let _ = Auth.auth().currentUser {
            
            Helper.login()
            
        } else {
            
            let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let loginVC = loginStoryboard.instantiateViewController(identifier: "Login") as! LoginViewController
            self.window?.rootViewController = loginVC
            
        }
        
        return true
    }
    
}

