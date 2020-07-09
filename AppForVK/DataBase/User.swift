//
//  User.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 07/02/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class User: Object {
    
    //MARK: - Basic fields
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var deactivated: String = ""
    @objc dynamic var isClosed: Int = 0
    @objc dynamic var canAccessClosed: Int = 0
    @objc dynamic var fullName: String = ""
    
    //MARK: - Optional fields
    @objc dynamic var nickname: String = ""
    @objc dynamic var online = "offline"
    @objc dynamic var photo_50: String = ""
    @objc dynamic var sex: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(json: JSON) {
        self.init()
        
        self.id = json["id"].intValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.deactivated = json["deactivated"].stringValue
        self.isClosed = json["is_closed"].intValue
        self.canAccessClosed = json["can_access_closed"].intValue
        self.fullName = json["last_name"].stringValue + " " + json["first_name"].stringValue
        self.nickname = json["nickname"].stringValue
        if json["online"].intValue == 1 {
            if json["online_mobile"].intValue == 1 { online = "online_mobile" } else { online = "online_pc" }
        } else {
            online = "offline"
        }
        self.photo_50 = json["photo_50"].stringValue
        self.sex = json["sex"].intValue
    }
}
