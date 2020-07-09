//
//  MyGroupController.swift
//  AppForVK
//
//  Created by Семериков Михаил on 26.12.2018.
//  Copyright © 2018 Семериков Михаил. All rights reserved.
//

import UIKit
import RealmSwift

class MyGroupController: UITableViewController {
    
    var groups = [Group]()
    let vkServiceProxy = VKServiceProxy(vkService: VKService())
    
    private let viewModelFactory = MyGroupCellViewModelFactory()
    private var viewModels: [MyGroupCellViewModel] = []
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup" {
            let allGroupController = segue.source as! AllGroupController
            if let indexPath = allGroupController.tableView.indexPathForSelectedRow {
                let group = allGroupController.filteredGroup[indexPath.row]
                if !groups.contains(group) {
                    groups.append(group)
                    tableView.reloadData()
                    vkServiceProxy.joinGroup(for: group.id)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 44
        
        vkServiceProxy.loadVKGroups(for: SessionApp.shared.userId) { [weak self] groups, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else if let groups = groups, let self = self {
                self.groups = groups
                self.saveGroups(groups)
                self.viewModels = self.viewModelFactory.constructViewModels(from: groups)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myGroupCell", for: indexPath) as? MyGroupCell else { return UITableViewCell() }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            vkServiceProxy.leaveGroup(for: groups[indexPath.row].id)
            groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Realm
    
    func saveGroups(_ groups: [Group]) {
        do {
            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: false)
            let realm = try Realm(configuration: config)
            realm.beginWrite()
            realm.add(groups, update: true)
            try realm.commitWrite()
            print(realm.configuration.fileURL!)
        } catch {
            print(error)
        }
    }
}
