//
//  AppDelegate.swift
//  InstaClone
//
//  Created by Afir Thes on 13.09.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    
    let tabBarDelegate = TabBarDelegate()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        

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
        
        

        self.window?.rootViewController = tabController
        
        return true
    }





}

