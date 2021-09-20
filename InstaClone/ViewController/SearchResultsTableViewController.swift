//
//  SearchResultsTableViewController.swift
//  InstaClone
//
//  Created by Afir Thes on 20.09.2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SearchResultsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var filteredResults: [UserModel] = [UserModel]()
    var shouldShowSearchResults: Bool = false
    let tableRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = tableRefreshControl
        } else {
            tableView.addSubview(tableRefreshControl)
        }
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false
        guard var searchQuery = searchController.searchBar.text else { return }
        tableRefreshControl.beginRefreshing()
        if searchQuery == "" {
            shouldShowSearchResults = false
            tableView.separatorStyle = .none
            tableRefreshControl.endRefreshing()
            tableView.reloadData()
            return
        }
        
        searchQuery = searchQuery.lowercased()
        
        guard let currentUser = Auth.auth().currentUser else { return }
        UserModel.collection.queryOrdered(byChild: "username").queryStarting(atValue: searchQuery).queryEnding(atValue: searchQuery + "\u{f8ff}").queryLimited(toLast: 30).observeSingleEvent(of: .value) { [weak self](snapshot) in
            
            guard let strongSelf = self else { return }
            
            var results: [UserModel] = [UserModel]()
            
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? [String: Any] {
                    if let name = value["username"] as? String {
                        if name.lowercased().contains(searchController.searchBar.text!.lowercased()) {
                            guard let user = UserModel(child) else { continue }
                            if user.userId != currentUser.uid {
                                results.append(user)
                            }
                        }
                    }
                }
            }
            
            strongSelf.filteredResults = results
            if searchController.searchBar.text != "" {
                strongSelf.shouldShowSearchResults = true
                DispatchQueue.main.async {
                    strongSelf.tableView.separatorStyle = .singleLine
                    strongSelf.tableRefreshControl.endRefreshing()
                    strongSelf.tableView.reloadData()
                }
            } else {
                strongSelf.shouldShowSearchResults = false
                DispatchQueue.main.async {
                    strongSelf.tableView.separatorStyle = .none
                    strongSelf.tableRefreshControl.endRefreshing()
                    strongSelf.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredResults.count
        }
        
        return 0
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchresultscell", for: indexPath)
     
        cell.textLabel?.text = filteredResults[indexPath.row].username
        cell.selectionStyle = .none
     
        return cell
     }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
