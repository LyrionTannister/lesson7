//
//  Video.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 07/04/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Video: Object {
    @objc dynamic var id = 0
    @objc dynamic var ownerId = 0
    @objc dynamic var title = ""
    @objc dynamic var duration = 0
    @objc dynamic var desc = ""
    @objc dynamic var date = 0
    @objc dynamic var comments = 0
    @objc dynamic var views = 0
    @objc dynamic var photo_130 = ""
    @objc dynamic var photo_320 = ""
    @objc dynamic var photo_640 = ""
    @objc dynamic var photo_800 = ""
    @objc dynamic var isFavorite: Bool = false
    @objc dynamic var player = ""
    @objc dynamic var platform = ""
    @objc dynamic var canAdd = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.ownerId = json["owner_id"].intValue
        self.title = json["title"].stringValue
        self.duration = json["duration"].intValue
        self.desc = json["description"].stringValue
        self.date = json["date"].intValue
        self.comments = json["comments"].intValue
        self.views = json["views"].intValue
        self.photo_130 = json["photo_130"].stringValue
        self.photo_320 = json["photo_320"].stringValue
        self.photo_640 = json["photo_640"].stringValue
        self.photo_800 = json["photo_800"].stringValue
        self.isFavorite = json["is_favorite"].boolValue
        self.player = json["player"].stringValue
        self.platform = json["platform"].stringValue
        self.canAdd = json["can_add"].intValue
    }
    
}
