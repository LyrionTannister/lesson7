//
//  AllGroupController.swift
//  AppForVK
//
//  Created by Семериков Михаил on 26.12.2018.
//  Copyright © 2018 Семериков Михаил. All rights reserved.
//

import UIKit
import Kingfisher

class AllGroupController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!

    private let searchController = UISearchController(searchResultsController: nil)
    var filteredGroup: [Group] = []
    private var searchActive : Bool = false

    private var offsetX: CGFloat = 0
    private var offsetY: CGFloat = 0
    private var textFieldInsideSearchBar: UITextField?
    private var iconView: UIImageView?
    
    private let vkService = VKService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        offsetX = searchBar.frame.width / 2 - 14
        offsetY = searchBar.searchFieldBackgroundPositionAdjustment.vertical
        searchBar.setPositionAdjustment(UIOffset(horizontal: offsetX, vertical: offsetY), for: .search)
        textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        iconView = textFieldInsideSearchBar?.leftView as? UIImageView
    }

    // MARK: - Search Bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchActive = false
        } else {
            vkService.searchVKGroups(q: searchText) { [weak self] groups, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else if let groups = groups, let self = self {
                    self.filteredGroup = groups
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            searchActive = true
        }
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
        searchActive = false
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Table view data source
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filteredGroup.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupCell", for: indexPath) as! AllGroupCell
        
        if searchActive {
            cell.allGroupName.text = filteredGroup[indexPath.row].name
            let imageURL = filteredGroup[indexPath.row].photo_50
            cell.allGroupImage.kf.setImage(with: URL(string: imageURL))
        } else {
            cell.allGroupName.text = ""
            cell.allGroupImage.image = nil
        }
        return cell
    }

}
