//
//  FriendsController.swift
//  AppForVK
//
//  Created by Семериков Михаил on 23.12.2018.
//  Copyright © 2018 Семериков Михаил. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class FriendsController: UITableViewController, UISearchBarDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var friendTableView: UITableView!
    
    //MARK: - Variables and constants
    
    private let vkService = VKService()
    private var friends: Results<User>?
    private let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    private let searchController = UISearchController(searchResultsController: nil)
    private var letters: [Character] = []
    private var lettersDictionary: [Character: [User]] = [:]
    private var notificationToken: NotificationToken?
    
    private var offsetX: CGFloat = 0
    private var offsetY: CGFloat = 0
    private var textFieldInsideSearchBar: UITextField?
    private var iconView: UIImageView?
    
    var friendsArr = [User]()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 44
        
        offsetX = searchBar.frame.width / 2 - 14
        offsetY = searchBar.searchFieldBackgroundPositionAdjustment.vertical
        searchBar.setPositionAdjustment(UIOffset(horizontal: offsetX, vertical: offsetY), for: .search)
        textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        iconView = textFieldInsideSearchBar?.leftView as? UIImageView
        
        let queue = OperationQueue()
        
        let operationLoading = BlockOperation( block: { [weak self] in
            guard let self = self else {
                return
            }
            
            self.vkService.loadVKFriends(for: SessionApp.shared.userId) { friends, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else if let friends = friends {
                    self.friendsArr = friends
                    //
                }
            }
            print("HERE 1!!!!")
        })
        
        let operationSaving = BlockOperation(
            block: { [weak self] in
                RealmProvider.save(items: self!.friendsArr)
                print("HERE 2!!!!")
            }
        )

        queue.addOperation(operationLoading)
        queue.addOperation(operationSaving)
        
        operationLoading.addDependency(operationSaving)

        
        vkService.loadVKFriends(for: SessionApp.shared.userId) { friends, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else if let friends = friends {
                RealmProvider.save(items: friends)
            }
        }
        pairTableAndRealm()
        tableView.keyboardDismissMode = .onDrag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    func pairTableAndRealm() {
        //let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        guard let realm = try? Realm() else { return }
        friends = realm.objects(User.self)
        self.updateFriendsIndex(friends: self.friends)
        self.updateFriendsNamesDictionary(friends: self.friends)
        
        notificationToken = friends?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView, let self = self else { return }
            
            switch changes {
            case .initial:
                tableView.reloadData()
                print("Initial")
            case .update(_, _, _, _):
                self.updateFriendsIndex(friends: self.friends)
                self.updateFriendsNamesDictionary(friends: self.friends)
                tableView.reloadData()
                print("Update")
                break
            case .error(let error):
                fatalError("\(error)")
                break
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return letters.count
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return letters.map { String($0) }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(letters[section])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let char = letters[section]
        let rowsCount: Int = lettersDictionary[char]?.count ?? 0
        return rowsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let char = letters[indexPath.section]
        let friendName = lettersDictionary[char]?[indexPath.row].fullName
        let friendOnlineStatus = lettersDictionary[char]?[indexPath.row].online
        let friendImageUrl = lettersDictionary[char]?[indexPath.row].photo_50
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendsCell
        cell.friendImage.kf.setImage(with: URL(string: friendImageUrl ?? "https://vk.com/images/camera_50.png"))
        cell.friendName.text = friendName
        
        cell.friendOnlineStatus.layer.masksToBounds = true
        if friendOnlineStatus != "offline" {
            if friendOnlineStatus == "online_mobile" {
                cell.onlineStatusConstraintWidth.constant = 8
                cell.onlineStatusConstraintHeight.constant = 12
            } else {
                cell.onlineStatusConstraintWidth.constant = 8
                cell.onlineStatusConstraintHeight.constant = 8
            }
            cell.friendOnlineStatus.image = UIImage(named: friendOnlineStatus ?? "offline")
        } else {
            cell.onlineStatusConstraintHeight.constant = 0
            cell.friendOnlineStatus.image = nil
        }
        cell.friendImage.layer.masksToBounds = true
        return cell
    }
    
    //MARK: - Setup searchBar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let realm = try? Realm(configuration: self.config) else { return }
        let fullName = searchText
        friends = realm.objects(User.self).filter("fullName CONTAINS %@", fullName)
        updateFriendsIndex(friends: friends)
        updateFriendsNamesDictionary(friends: friends)
        if (searchText.count == 0) {
            friends = realm.objects(User.self)
            updateFriendsIndex(friends: friends)
            updateFriendsNamesDictionary(friends: friends)
            UIView.transition(with: searchBar, duration: 0.5, options: .transitionCrossDissolve, animations: {self.searchBar.setShowsCancelButton(false, animated: true)})
            searchBar.setPositionAdjustment(UIOffset(horizontal: offsetX, vertical: offsetY), for: .search)
            searchBar.resignFirstResponder()
            searchBar.text = nil
            searchBar.endEditing(true)
            hideKeyboard()
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.transition(with: searchBar, duration: 0.5, options: .transitionCrossDissolve, animations: {self.searchBar.setShowsCancelButton(true, animated: true)})
        self.searchBar.setPositionAdjustment(UIOffset(horizontal: 0, vertical: 0), for: .search)
        UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {self.iconView?.transform = CGAffineTransform(translationX: -20, y: 0)}) { (true) in self.iconView?.transform = .identity}
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.transition(with: searchBar, duration: 0.5, options: .transitionCrossDissolve, animations: {self.searchBar.setShowsCancelButton(false, animated: true)})
        searchBar.setPositionAdjustment(UIOffset(horizontal: offsetX, vertical: offsetY), for: .search)
        searchBar.resignFirstResponder()
        searchBar.text = nil
        searchBar.endEditing(true)
        guard let realm = try? Realm(configuration: self.config) else { return }
        friends = realm.objects(User.self)
        updateFriendsIndex(friends: friends)
        updateFriendsNamesDictionary(friends: friends)
        hideKeyboard()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        hideKeyboard()
    }
    
    @objc func hideKeyboard() {
        friendTableView?.endEditing(true)
    }
    
    //MARK: - Prepare data
    
    func updateFriendsNamesDictionary(friends: Results<User>?) {
        guard let friends = friends else { return }
        let sortedFriends = friends.sorted(by: { $0.fullName < $1.fullName })
        lettersDictionary = SectionIndexManager.getFriendIndexDictionary(array: sortedFriends)
    }
    
    func updateFriendsIndex(friends: Results<User>?) {
        guard let friends = friends else { return }
        let arrayFriends = Array(friends)
        letters = SectionIndexManager.getOrderedIndexArray(array: arrayFriends)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFriends" {
            let friendsCollectionController : FriendsCollectionController = segue.destination as! FriendsCollectionController
            if let selection = self.tableView.indexPathForSelectedRow {
                let char = letters[selection.section]
                if let selectedFriend = lettersDictionary[char]?[selection.row] {
                    friendsCollectionController.user = selectedFriend.id
                }
            }
        }
    }
}
