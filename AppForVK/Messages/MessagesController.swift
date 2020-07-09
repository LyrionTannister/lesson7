//
//  MessagesController.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 22/04/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class MessagesController: UITableViewController {
    
    private let vkService = VKService()
    private let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    private var notificationToken: NotificationToken?
    private var messages: Results<Message>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        vkService.loadMessages() { messages, users, groups, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else if let messages = messages?.filter({$0.lastMessage != ""}), let users = users, let groups = groups {
                RealmProvider.save(items: messages)
                RealmProvider.save(items: users)
                RealmProvider.save(items: groups)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pairTableAndRealm()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        notificationToken?.invalidate()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessagesCell
        guard let messages = messages else { return UITableViewCell() }
        cell.friendFullName.text = messages[indexPath.row].owner?.userName
        cell.lastMessages.text = messages[indexPath.row].lastMessage
        
        return cell
    }

    func pairTableAndRealm() {
        guard let realm = try? Realm(configuration: config) else { return }
        messages = realm.objects(Message.self)
        notificationToken = messages?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update:
                tableView.reloadData()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }

}
