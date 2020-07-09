//
//  NewsItem.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 27/04/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import Foundation
import SwiftyJSON

class NewsItem {
    let id: Int
    let sourceID: Int
    let text: String
    let date: Date
    var source: NewsSource?
    var photos: [PhotoNews]
    var gif: GIF?
    var likesCount: Int
    var liked: Bool
    var commentsCount: Int
    var repostsCount: Int
    var viewsCount: Int
    var video: VideoNews?
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.sourceID = json["source_id"].intValue
        self.text = json["text"].stringValue
        let timeInterval = json["date"].doubleValue
        self.date = Date(timeIntervalSince1970: timeInterval)
        self.likesCount = json["likes"]["count"].intValue
        
        if json["likes"]["user_likes"].intValue == 1 {
            liked = true
        } else {
            liked = false
        }
        self.commentsCount = json["comments"]["count"].intValue
        self.repostsCount = json["reposts"]["count"].intValue
        self.viewsCount = json["views"]["count"].intValue
        
        
        let photosJSON = json["attachments"].arrayValue.filter({ $0["type"].stringValue == "photo" })
        self.photos = photosJSON.compactMap { PhotoNews(json: $0) }
        
        let docsJSON = json["attachments"].arrayValue.filter({ $0["type"].stringValue == "doc" }).map { $0["doc"] }
        
        if !docsJSON.isEmpty {
            let gifsJSON = docsJSON.filter { $0["type"].intValue == 3 }
            if !gifsJSON.isEmpty {
                self.gif = GIF(json: gifsJSON[0])
            }
        }
        
        let videoJSON = json["attachments"].arrayValue.filter({ $0["type"].stringValue == "video" })
        if !videoJSON.isEmpty {
            self.video = VideoNews(json: videoJSON[0])
        }

    }
    
}

class PhotoNews: ImageNodeRepresentable {
    let id: Int
    let date: Date
    let width: Int
    let height: Int
    let url: URL
    var aspectRatio: CGFloat { return CGFloat(height)/CGFloat(width) }
    
    init?(json: JSON) {
        guard let sizesArray = json["photo"]["sizes"].array,
            let xSize = sizesArray.first(where: { $0["type"].stringValue == "x" }),
            let url = URL(string: xSize["url"].stringValue) else { return nil }
        
        self.width = xSize["width"].intValue
        self.height = xSize["height"].intValue
        self.url = url
        let timeInterval = json["date"].doubleValue
        self.date = Date(timeIntervalSince1970: timeInterval)
        self.id = json["id"].intValue
    }
}

class GIF: ImageNodeRepresentable {
    let id: Int
    let date: Date
    let url: URL
    let width: Int
    let height: Int
    var aspectRatio: CGFloat { return CGFloat(height)/CGFloat(width) }
    
    init?(json: JSON) {
        guard let url = URL(string: json["url"].stringValue) else { return nil }
        self.id = json["id"].intValue
        self.url = url
        let timeInterval = json["date"].doubleValue
        self.date = Date(timeIntervalSince1970: timeInterval)
        self.width = json["preview"]["video"]["width"].intValue
        self.height = json["preview"]["video"]["height"].intValue
    }
}

class VideoNews: ImageNodeRepresentable {
    private let vkService = VKService()
    
    let id: Int
    let ownerId: Int
    let url: URL
    let width: Int
    let height: Int
    var aspectRatio: CGFloat { return CGFloat(height)/CGFloat(width) }

    init?(json: JSON) {
        self.id = json["id"].intValue
        self.ownerId = json["owner_id"].intValue
        self.width = json["width"].intValue
        self.height = json["height"].intValue
        let request = (json["owner_id"].stringValue) + "_" + (json["id"].stringValue)
        //let player = vkService.loadVideo(q: request)
        guard let url = URL(string: request) else { return nil }
        self.url = url
    }
}

protocol ImageNodeRepresentable {
    var url: URL { get }
    var aspectRatio: CGFloat { get }
}
