//
//  HomeViewController.swift
//  InstaClone
//
//  Created by Afir Thes on 13.09.2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SDWebImage

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts: NSMutableArray = []
    
    let PAGINATION_COUNT: UInt = 2
    
    var newQuery: DatabaseQuery?
    
    var oldRef: DatabaseReference?
    
    var firstChild: DataSnapshot?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = CGFloat(88.0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedTableViewCell")
        tableView.register(UINib(nibName: "StoriesTableViewCell", bundle: nil), forCellReuseIdentifier: "StoriesTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        var leftBarItemImage = UIImage(named: "camera_nav_icon")
        leftBarItemImage = leftBarItemImage?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftBarItemImage, style: .plain, target: self, action: #selector(newPostButtonDidTouch))
        let profileImageView = UIImageView(image: UIImage(named: "logo_nav_icon"))
        self.navigationItem.titleView = profileImageView
        
        loadData()
    }
    
    func loadData() {
        
        let postRef: DatabaseReference = PostModel.collection
        let postQuery = postRef.queryOrderedByKey().queryLimited(toLast: PAGINATION_COUNT)
    
        postQuery.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let strongSelf = self else { return }
            
            for item in snapshot.children {
                guard let snapshot = item as? DataSnapshot else { continue }
                guard let post = PostModel(snapshot) else { continue }
                strongSelf.posts.insert(post, at: 0)
            }
            
            strongSelf.firstChild = snapshot.children.allObjects.first as? DataSnapshot
            let lastChild = snapshot.children.allObjects.last as? DataSnapshot
            strongSelf.objserveNewItems(lastChild, newRef: postRef)
            
            
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
            }
        }
        
        oldRef?.removeAllObservers()
        
        oldRef = postRef
        
        oldRef?.observe(.childRemoved, with: {[weak self]  (snapshot) in
            guard let strongSelf = self else { return }
            
            for item in strongSelf.posts {
                if let post = item as? PostModel, snapshot.key == post.key {
                    strongSelf.posts.remove(item)
                }
            }
            
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
            }
        })
    }
    
    
    func objserveNewItems(_ lastChild: DataSnapshot?, newRef: DatabaseReference) {
        newQuery?.removeAllObservers()
        newQuery = newRef.queryOrderedByKey()
        if let startKey = lastChild?.key {
            newQuery = newQuery?.queryStarting(atValue: startKey)
        }
        newQuery?.observe(.childAdded, with: { [weak self] (snapshot) in
            guard let strongSelf = self else { return }
            if snapshot.key != lastChild?.key {
                if let post = PostModel(snapshot) {
                    
                    strongSelf.posts.insert(post, at: 0)
                    
                    DispatchQueue.main.async {
                        strongSelf.tableView.reloadData()
                    }
                    
                }
            }
        })
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if let lastIndex = self.tableView.indexPathsForVisibleRows?.last {
            if lastIndex.row >= self.posts.count - 2 {
                loadMore()
            }
        }
    }
    
    func loadMore() {
        let postsRef: DatabaseReference = PostModel.collection
        var paginationQuery = postsRef.queryOrderedByKey().queryLimited(toLast:  PAGINATION_COUNT + 1)
        
        if let firstKey = firstChild?.key {
            paginationQuery = paginationQuery.queryEnding(atValue: firstKey)
            paginationQuery.observeSingleEvent(of: .value) { [weak self] (snapshot) in
                guard let strongSelf = self else { return }
                
                let items = snapshot.children.allObjects
                
                var indexes: [IndexPath] = []
                
                if items.count > 1 {
                    for i in 2...items.count {
                        
                        let data = items[items.count - i] as! DataSnapshot
                        
                        indexes.append(IndexPath(row: strongSelf.posts.count, section: 0))
                        
                        if let post = PostModel(data) {
                            
                            strongSelf.posts.add(post)
                            
                        }
                        
                    }
                    
                    strongSelf.firstChild = snapshot.children.allObjects.first as? DataSnapshot
                    DispatchQueue.main.async {
                        strongSelf.tableView.insertRows(at: indexes, with: .fade)
                        //strongSelf.tableView.reloadData()
                    }
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoriesTableViewCell") as! StoriesTableViewCell
            return cell
        }
        
        let feedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell") as! FeedTableViewCell
        let currentIndex = indexPath.row - 1
        let post = posts[currentIndex] as! PostModel
        feedTableViewCell.postImage.sd_cancelCurrentImageLoad()
        feedTableViewCell.postImage.sd_setImage(with: post.imageURL, completed: nil)
        feedTableViewCell.postCommentLabel.text = post.caption
        
        feedTableViewCell.postImage.backgroundColor = UIColor.lightGray
        
        feedTableViewCell.userRef = UserModel.collection.child(post.userId)
        feedTableViewCell.likesRef = LikesModel.collection.child(post.key)
        feedTableViewCell.postModel = post
        
        feedTableViewCell.feedDelegate = self
        feedTableViewCell.deletePostDelegate = self
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM, yyyy hh:mm"
        feedTableViewCell.dateLabel.text = dateFormatter.string(from: post.date)
        
        
//        if postData.comments.count > 0 {
//            let commentTitle = postData.comments.count == 1 ? "View 1 comment" : "View all \(postData.comments.count) comments"
//            cell.commentCountButton.setTitle(commentTitle, for: .normal)
//            cell.commentCountButton.isEnabled = true
//        }
//        else {
//            cell.commentCountButton.setTitle("0 comments", for: .normal)
//            cell.commentCountButton.isEnabled = false
//        }
        
        feedTableViewCell.profileDelegate = self
        feedTableViewCell.postModel = post
        
        return feedTableViewCell
    }
    
    @objc func newPostButtonDidTouch() {
        let newPostStoryboard = UIStoryboard(name: "NewPost", bundle: nil)
        let newPostVC = newPostStoryboard.instantiateViewController(withIdentifier: "NewPost") as! NewPostViewController
        let navController = UINavigationController(rootViewController: newPostVC)
        present(navController, animated: true, completion: nil)
    }
    
    deinit {
        newQuery?.removeAllObservers()
        oldRef?.removeAllObservers()
    }

}

extension HomeViewController: FeedDataDelegate {
    
    func commentsDidTouch(post: PostModel, likesModel: LikesModel, userModel: UserModel) {
        let postStoryboard = UIStoryboard(name: "Post", bundle: nil)
        let postVC = postStoryboard.instantiateViewController(withIdentifier: "Post") as! PostViewController
        postVC.postModel = post
        postVC.likesModel = likesModel
        postVC.userModel = userModel
        navigationController?.pushViewController(postVC, animated: true)
    }
    
}

extension HomeViewController: ProfileDelegate {
    
    func userNameDidTouch(userId: String) {
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileVC = profileStoryboard.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
        profileVC.userId = userId
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
}

extension HomeViewController: PostDeleDelegate {
    func confirmDelete(postId: String) {
        let alert = UIAlertController(title: "Delete Post", message: "Are you sure?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            PostModel.deletePost(postId: postId)
            alert.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

