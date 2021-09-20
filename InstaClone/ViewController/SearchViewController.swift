//
//  SearchViewController.swift
//  InstaClone
//
//  Created by Afir Thes on 13.09.2021.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var searchController: UISearchController!
    var posts: NSMutableArray = []
    let PAGINATION_COUNT: UInt = 10
    var oldRef: DatabaseReference?
    var firstChild: DataSnapshot?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        let searchResultVC = storyboard.instantiateViewController(withIdentifier: "SearchResults") as! SearchResultsTableViewController
        
        searchController = UISearchController(searchResultsController: searchResultVC)
        
        searchController.searchResultsUpdater = searchResultVC
        
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.showsCancelButton = false
        for subView in searchController.searchBar.subviews {
            for subView1 in subView.subviews {
                if let textField = subView1 as? UITextField {
                    textField.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0)
                    textField.textAlignment = NSTextAlignment.left
                }
            }
        }
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
        let searchBarContainer = SearchBarContainerView(customSearchBar: searchController.searchBar)
        searchBarContainer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        navigationItem.titleView = searchBarContainer
        definesPresentationContext = true
        self.loadData()
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
            DispatchQueue.main.async {
                strongSelf.collectionView.reloadData()
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
                strongSelf.collectionView.reloadData()
            }
        })
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if let lastIndex = self.collectionView.indexPathsForVisibleItems.last {
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
                        strongSelf.collectionView.insertItems(at: indexes)
                        //strongSelf.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExploreCollectionViewCell", for: indexPath) as! ExploreCollectionViewCell
        let post = posts[indexPath.row] as! PostModel
        cell.exploreImage.sd_cancelCurrentImageLoad()
        cell.exploreImage.sd_setImage(with: post.imageURL, completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.row] as! PostModel
        let postStoryboard = UIStoryboard(name: "Post", bundle: nil)
        let postVC = postStoryboard.instantiateViewController(withIdentifier: "Post") as! PostViewController
        postVC.postModel = post
        navigationController?.pushViewController(postVC, animated: true)
    }

}
