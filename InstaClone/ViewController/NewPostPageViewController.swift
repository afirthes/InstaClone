//
//  NewPostPageViewController.swift
//  InstaClone
//
//  Created by Afir Thes on 15.09.2021.
//

import UIKit

class NewPostPageViewController: UIPageViewController, UIPageViewControllerDelegate {

    var orderedViewControllers: [UIViewController] = [UIViewController]()
    var currentIndex: Int = 0
    var pagesToShow: [NewPostPagesToShow] = NewPostPagesToShow.pagesToShow()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
        
        for pageToShow in pagesToShow {
            let page = newViewController(pageToShow: pageToShow)
            orderedViewControllers.append(page)
        }
        
        if let firstViewcController = orderedViewControllers.first {
            setViewControllers([firstViewcController], direction: .forward, animated: true, completion: nil)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewPostPageViewController.newPage(notification:)), name: NSNotification.Name.init("newPage"), object: nil)

    }
    
    @objc func newPage(notification: NSNotification) {
        if let receivedObject = notification.object as? NewPostPagesToShow {
            showViewController(index: receivedObject.rawValue)
        }
    }
    
    func newViewController(pageToShow: NewPostPagesToShow) -> UIViewController {
        var viewController: UIViewController!
        let newPostStoryboard = UIStoryboard(name: "NewPost", bundle: nil)
        switch pageToShow {
            case .camera:
                viewController = newPostStoryboard.instantiateViewController(identifier: pageToShow.identifier) as! CameraViewController
            case .library:
                viewController = newPostStoryboard.instantiateViewController(identifier: pageToShow.identifier) as! PhotoLibraryViewController
        }
        return viewController
    }
    
    
    func showViewController(index: Int) {
        if currentIndex > index {
            setViewControllers([orderedViewControllers[index]], direction: .reverse, animated: true, completion: nil)
        } else if currentIndex < index {
            setViewControllers([orderedViewControllers[index]], direction: .forward, animated: true, completion: nil)
        }
        currentIndex = index
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "newPage"), object: nil)
    }
    
}

extension NewPostPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        guard orderedViewControllersCount != nextIndex else { return nil }
        guard orderedViewControllersCount > nextIndex else { return nil }
        return orderedViewControllers[nextIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else { return nil }
        let prevIndex = viewControllerIndex - 1
        guard prevIndex >= 0 else { return nil }
        return orderedViewControllers[prevIndex]
    }
    
    
}
