//
//  HomeViewController.swift
//  InstaClone
//
//  Created by Afir Thes on 13.09.2021.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var posts: [Post] = {
        let model = Model()
        return model.postList
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // Actial value doesnt matter
        tableView.estimatedRowHeight = CGFloat(88.0)
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedTableViewCell")
        tableView.register(UINib(nibName: "StoriesTableViewCell", bundle: nil), forCellReuseIdentifier: "StoriesTableViewCell")
        
        tableView.tableFooterView = UIView()
        
        var rightBarItemImage = UIImage(named: "send_nav_icon")
        // Prevent tinting from iOS
        rightBarItemImage = rightBarItemImage?.withRenderingMode(.alwaysOriginal)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarItemImage, style: .plain, target: nil, action: nil)
        
        
        var leftBarItemImage = UIImage(named: "camera_nav_icon")
        // Prevent tinting from iOS
        leftBarItemImage = leftBarItemImage?.withRenderingMode(.alwaysOriginal)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: leftBarItemImage, style: .plain, target: nil, action: nil)
        
        let profileImageview = UIImageView(image: UIImage(named: "logo_nav_icon"))
        self.navigationItem.titleView = profileImageview
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count + 1 // 1 is for collection view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoriesTableViewCell") as! StoriesTableViewCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell") as! FeedTableViewCell
        let currentIndex = indexPath.row + 1 // compensate from collection view row
        let postData = posts[currentIndex]
        
        cell.profileImage.image = postData.user.profileImage
        cell.postImage.image = postData.postImage
        cell.dateLabel.text = postData.datePosted
        cell.likesCountLabel.text = "\(postData.likesCount) likes"
        cell.postCommentLabel.text = postData.postComment
        cell.userNameTitleButton.setTitle(postData.user.name, for: .normal)
        cell.commentCountButton.setTitle("View all \(postData.commentCount) comments", for: .normal)
        
        return cell
    }
    

}
