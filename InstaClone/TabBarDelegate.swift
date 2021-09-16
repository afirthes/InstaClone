//
//  TabBarDelegate.swift
//  InstaClone
//
//  Created by Afir Thes on 15.09.2021.
//

import Foundation
import UIKit

class TabBarDelegate: NSObject, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let navigationController = viewController as? UINavigationController
        _ = navigationController?.popViewController(animated: false)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let selectedViewController = tabBarController.selectedViewController
        
        guard let _selectedViewController = selectedViewController else {
            return false
        }
        
        if viewController == _selectedViewController { return false }
        
        guard let controllerIndex = tabBarController.viewControllers?.index(of: viewController) else {
            return true
        }
        
        if controllerIndex == 2 {
            let newPostStoryboard = UIStoryboard(name: "NewPost", bundle: nil)
            let newPostVC = newPostStoryboard.instantiateViewController(identifier: "NewPost") as NewPostViewController
            
            let navController = UINavigationController(rootViewController: newPostVC)
            _selectedViewController.present(navController, animated: true, completion: nil)
            return false
        }
        
        let navigationController = viewController as? UINavigationController
        _ = navigationController?.popToRootViewController(animated: false)
        
        return true
    }
    
}
