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
        
        let tabController = UITabBarController()
        
        let homeStoryBoard = UIStoryboard(name: "Home", bundle: nil)
        let searchStoryBoard = UIStoryboard(name: "Search", bundle: nil)
        let newPostStoryBoard = UIStoryboard(name: "NewPost", bundle: nil)
        let profileStoryBoard = UIStoryboard(name: "Profile", bundle: nil)
        let activityStoryBoard = UIStoryboard(name: "Activity", bundle: nil)
        
        let homeVC = homeStoryBoard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
        
        let profileVC = profileStoryBoard.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
        let searchVC = searchStoryBoard.instantiateViewController(withIdentifier: "Search") as! SearchViewController
        let newPostVC = newPostStoryBoard.instantiateViewController(withIdentifier: "NewPost") as! NewPostViewController
        let activityVC = activityStoryBoard.instantiateViewController(withIdentifier: "Activity") as! ActivityViewController
        
        let vcData: [(UIViewController, UIImage, UIImage)] = [
            (homeVC, UIImage(named: "home_tab_icon")!, UIImage(named: "home_selected_tab_icon")!),
            (searchVC, UIImage(named: "search_tab_icon")!, UIImage(named: "search_selected_tab_icon")!),
            (newPostVC, UIImage(named: "post_tab_icon")!, UIImage(named: "post_tab_icon")!),
            (activityVC, UIImage(named: "activity_tab_icon")!, UIImage(named: "activity_selected_tab_icon")!),
            (profileVC, UIImage(named: "profile_tab_icon")!, UIImage(named: "profile_selected_tab_icon")!)
        ]
        
        let vcs = vcData.map { (vc, defaultImage, selectedImage) -> UINavigationController in
            let nav = UINavigationController(rootViewController: vc)
            nav.tabBarItem.image = defaultImage
            nav.tabBarItem.selectedImage = selectedImage
            return nav
        }
        
        tabController.viewControllers = vcs
        tabController.tabBar.isTranslucent = false
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        tabController.delegate = tabBarDelegate
        
        if let items = tabController.tabBar.items {
            for item in items {
                if let image = item.image {
                    item.image = image.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                }
                if let selectedImage = item.selectedImage {
                    item.selectedImage = selectedImage.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                }
                item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            }
        }
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().backgroundColor = UIColor.white
        
        
        guard let window = appDelegate.window else { return }
        window.rootViewController = tabController
    }
    
}
