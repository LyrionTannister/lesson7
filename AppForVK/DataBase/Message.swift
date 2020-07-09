//
//  Message.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 22/04/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Message: Object {
    
    @objc dynamic var userId = 0
    @objc dynamic var lastMessage = ""
    @objc dynamic var owner: Owner?
    
    convenience init(json: JSON) {
        self.init()
        self.userId = json["conversation"]["peer"]["id"].intValue
        self.lastMessage = json["last_message"]["text"].stringValue
    }
    
    override static func primaryKey() -> String? {
        return "userId"
    }
    
}
