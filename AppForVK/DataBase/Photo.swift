//
//  Photo.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 12/02/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Photo: Object {
    
    //MARK: - Basic fields
    @objc dynamic var id: Int = 0
    @objc dynamic var ownerId: Int = 0
    @objc dynamic var extended: Int = 0
    @objc dynamic var offset: Int = 0
    @objc dynamic var count: Int = 0
    @objc dynamic var photoSizes: Int = 0
    @objc dynamic var noServiceAlbums: Int = 0
    @objc dynamic var needHidden: Int = 0
    @objc dynamic var skipHidden: Int = 0
    @objc dynamic var url: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
     convenience init(json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.ownerId = json["owner_id"].intValue
        self.extended = json["extended"].intValue
        self.offset = json["offset"].intValue
        self.count = json["count"].intValue
        self.photoSizes = json["photo_sizes"].intValue
        self.noServiceAlbums = json["no_service_albums"].intValue
        self.needHidden = json["need_hidden"].intValue
        self.skipHidden = json["skip_hidden"].intValue
        self.url = json["sizes"][4]["url"].stringValue
    }
}
