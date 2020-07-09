//
//  Owner.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 06/04/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Owner: Object {
    
    @objc dynamic var ownerId = 0
    @objc dynamic var ownerPhoto = ""
    @objc dynamic var userName = ""
    @objc dynamic var groupName = ""
    
    convenience init(json: JSON) {
        self.init()
        self.ownerId = json["id"].intValue
        self.ownerPhoto = json["photo_50"].stringValue
        self.userName = json["last_name"].stringValue + " " + json["first_name"].stringValue
        self.groupName = json["name"].stringValue
    }
    
    override static func primaryKey() -> String {
        return "ownerId"
    }
}
