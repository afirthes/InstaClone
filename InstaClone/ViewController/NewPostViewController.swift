//
//  NewPostViewController.swift
//  InstaClone
//
//  Created by Afir Thes on 13.09.2021.
//

import UIKit

enum NewPostPagesToShow: Int {
    case library, camera
    
    var identifier: String {
        switch self {
            case .library:
                return "PhotoLibraryVC"
            case .camera:
                return "CameraVC"
        }
    }
    
    static func pagesToShow() -> [NewPostPagesToShow] {
        return [.library, .camera]
    }
}

class NewPostViewController: UIViewController {

    @IBAction func libraryButtonDidTouch(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("newPage"), object: NewPostPagesToShow.library)
    }
    
    @IBAction func photoButtonDidTouch(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("newPage"), object: NewPostPagesToShow.camera)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        NotificationCenter.default.addObserver(self, selector: #selector(NewPostViewController.moveToCreatePost(notification:)), name: NSNotification.Name(rawValue: "createNewPost"), object: nil)
    }
    
    @objc func moveToCreatePost(notification: NSNotification) {
        if let receivedObject = notification.object as? UIImage {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "CreatePost", sender: receivedObject)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreatePost" {
            guard let postImage = sender as? UIImage else { return }
            let destinationVC = segue.destination as! CreatePostViewController
            destinationVC.postImage = postImage
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "createNewPost"), object: nil)
    }

}
