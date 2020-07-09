//
//  News.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 24/01/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class News: Object {
    @objc dynamic var newsType = ""
    @objc dynamic var titlePostTime: Double = 0.0
    @objc dynamic var geoCoordinates = ""
    @objc dynamic var geoPlaceTitle = ""
    
    @objc dynamic var postSource_id = 0
    @objc dynamic var postText = ""
    @objc dynamic var attachments_typePhoto: String = ""
    @objc dynamic var attachmentsType = ""
    @objc dynamic var attachments_photoWidth = 0
    @objc dynamic var attachments_photoHeight = 0
    @objc dynamic var attachmentsId = 0
    @objc dynamic var attachmentsOwnerId = 0
    @objc dynamic var post_id = 0
    
    //MARK: - Repost
    @objc dynamic var repostOwnerId = 0
    @objc dynamic var repostPhoto = ""
    @objc dynamic var repostPhotoWidth = 0
    @objc dynamic var repostPhotoHeight = 0
    @objc dynamic var repostText = ""
    @objc dynamic var repostDate: Double = 0.0
    
    @objc dynamic var postImage = ""
    
    //MARK: - Likes, comments, share, views
    @objc dynamic var commentsCount = 0
    @objc dynamic var likesCount = 0
    @objc dynamic var commentCanPost = 0
    @objc dynamic var userLikes = 0
    @objc dynamic var repostsCount = 0
    @objc dynamic var viewsCount = 0
    
    override static func primaryKey() -> String? {
        return "post_id"
    }
    
    convenience init(json: JSON) {
        self.init()
        self.newsType = json["type"].stringValue
        self.postSource_id = json["source_id"].intValue
        self.postText = json["text"].stringValue
        self.titlePostTime = json["date"].doubleValue
        self.attachmentsType = json["attachments"][0]["type"].stringValue
        
        let newsType = json["type"].stringValue
        switch newsType {
        case "photo":
            let sizesCount = json["photos"]["items"][0]["sizes"].count
            for i in 0..<(sizesCount-1) {
                let width = json["photos"]["items"][0]["sizes"][i]["width"].intValue
                
                if self.attachments_photoWidth != 604 {
                    if width > self.attachments_photoWidth {
                        self.attachments_typePhoto = json["photos"]["items"][0]["sizes"][i]["url"].stringValue
                        self.attachments_photoWidth = json["photos"]["items"][0]["sizes"][i]["width"].intValue
                        self.attachments_photoHeight = json["photos"]["items"][0]["sizes"][i]["height"].intValue
                    }
                }
            }
        case "post":
            let typeAttachments = json["attachments"][0]["type"]
            switch typeAttachments {
            case "photo":
                let sizesCount = json["attachments"][0]["photo"]["sizes"].count
                for i in 0..<(sizesCount-1) {
                    let width = json["attachments"][0]["photo"]["sizes"][i]["width"].intValue
                    
                    if self.attachments_photoWidth != 604 {
                        if width > self.attachments_photoWidth {
                            self.attachments_typePhoto = json["attachments"][0]["photo"]["sizes"][i]["url"].stringValue
                            self.attachments_photoWidth = json["attachments"][0]["photo"]["sizes"][i]["width"].intValue
                            self.attachments_photoHeight = json["attachments"][0]["photo"]["sizes"][i]["height"].intValue
                        }
                    }
                }
            case "link":
                let sizesCount = json["attachments"][0]["link"]["photo"]["sizes"].count
                if sizesCount != 0 {
                    for i in 0..<(sizesCount-1) {
                        
                        if self.attachments_photoWidth != 604 {
                            if json["attachments"][0]["link"]["photo"]["sizes"][i]["width"].intValue > self.attachments_photoWidth {
                                self.attachments_typePhoto = json["attachments"][0]["link"]["photo"]["sizes"][i]["url"].stringValue
                                self.attachments_photoWidth = json["attachments"][0]["link"]["photo"]["sizes"][i]["width"].intValue
                                self.attachments_photoHeight = json["attachments"][0]["link"]["photo"]["sizes"][i]["height"].intValue
                            }
                        }
                    }
                }
            case "video":
                self.attachments_typePhoto = json["attachments"][0]["video"]["photo_800"].stringValue
                self.attachments_photoWidth = json["attachments"][0]["video"]["width"].intValue
                self.attachments_photoHeight = json["attachments"][0]["video"]["height"].intValue
                self.attachmentsId = json["attachments"][0]["video"]["id"].intValue
                self.attachmentsOwnerId = json["attachments"][0]["video"]["owner_id"].intValue
            case "wall_photo":
                let sizesCount = json["attachments"][0]["photo"]["sizes"].count
                for i in 0..<(sizesCount-1) {
                    self.attachments_typePhoto = json["attachments"][0]["photo"]["sizes"][0]["url"].stringValue
                    self.attachments_photoWidth = json["attachments"][0]["photo"]["sizes"][0]["width"].intValue
                    self.attachments_photoHeight = json["attachments"][0]["photo"]["sizes"][0]["height"].intValue
                    
                    if self.attachments_photoWidth != 604 {
                        if json["attachments"][0]["photo"]["sizes"][i]["width"].intValue > self.attachments_photoWidth {
                            self.attachments_typePhoto = json["attachments"][0]["photo"]["sizes"][i]["url"].stringValue
                            self.attachments_photoWidth = json["attachments"][0]["photo"]["sizes"][i]["width"].intValue
                            self.attachments_photoHeight = json["attachments"][0]["photo"]["sizes"][i]["height"].intValue
                        }
                    }
                }
                //            self.attachments_typePhoto = json["attachments"][0]["photo"]["sizes"][3]["url"].stringValue
                //            self.attachments_photoWidth = json["attachments"][0]["photo"]["sizes"][3]["width"].intValue
            //            self.attachments_photoHeight = json["attachments"][0]["photo"]["sizes"][3]["height"].intValue
            case "doc":
                self.attachments_typePhoto = json["attachments"][0]["doc"]["url"].stringValue
                //self.attachments_photoWidth = json["attachments"][0]["photo"]["sizes"][3]["width"].intValue
            //self.attachments_photoHeight = json["attachments"][0]["photo"]["sizes"][3]["height"].intValue
            default:
                print("Another type of attachments")
            }
        default:
            print("Another type of news")
        }
        self.postImage = json["photos"][0]["src"].stringValue
        
        self.repostOwnerId = json["copy_history"][0]["owner_id"].intValue
        self.repostText = json["copy_history"][0]["text"].stringValue
        self.repostPhoto = json["copy_history"][0]["attachments"][0]["photo"]["sizes"][6]["url"].stringValue
        self.repostPhotoWidth = json["copy_history"][0]["attachments"][0]["photo"]["sizes"][6]["width"].intValue
        self.repostPhotoHeight = json["copy_history"][0]["attachments"][0]["photo"]["sizes"][6]["height"].intValue
        self.repostDate = json["copy_history"][0]["date"].doubleValue
        
        self.post_id = json["post_id"].intValue
        self.geoCoordinates = json["geo"]["coordinates"].stringValue
        self.geoPlaceTitle = json["geo"]["place"]["title"].stringValue
        
        self.commentsCount = json["comments"]["count"].intValue
        self.likesCount = json["likes"]["count"].intValue
        self.commentCanPost = json["comments"]["can_post"].intValue
        self.userLikes = json["likes"]["user_likes"].intValue
        self.repostsCount = json["reposts"]["count"].intValue
        self.viewsCount = json["views"]["count"].intValue
    }
    
}
