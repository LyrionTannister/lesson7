//
//  VkNewsService.swift
//  AppForVK
//
//  Created by Mad Brains on 01.07.2020.
//  Copyright © 2020 Семериков Михаил. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class VkNewsService {
    let baseUrl = "https://api.vk.com"
    let versionAPI = "5.92"
    
    static let sharedManager: Session = {
        let config = URLSessionConfiguration.default
        
        config.timeoutIntervalForRequest = 40
        
        let manager = Session(configuration: config)
        return manager
    }()
    
    func loadVkNewsFeed(completion: ((VkNews?, Error?) -> Void)? = nil) {
        let path = "/method/newsfeed.get"
        let parameters: Parameters = [
            "filters": "post,photo",
        
            "count": 30,
            "access_token": SessionApp.shared.token,
            "v": versionAPI
        ]
        let url = baseUrl + path
        
        VkNewsService.sharedManager.request(url, method: .get, parameters: parameters).responseJSON(queue: .global(qos: .userInteractive)) { response in
            print(VKService.sharedManager.request(url, method: .get, parameters: parameters))
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var news = [News]()
                var users = [Owner]()
                var groups = [Owner]()
                
                let jsonGroup = DispatchGroup()
                
                DispatchQueue.global().async(group: jsonGroup) {
                    news = json["response"]["items"].arrayValue.map { News(json: $0) }
                }
                
                DispatchQueue.global().async(group: jsonGroup) {
                    users = json["response"]["profiles"].arrayValue.map { Owner(json: $0) }
                }
                
                DispatchQueue.global().async(group: jsonGroup) {
                    groups = json["response"]["groups"].arrayValue.map { Owner(json: $0) }
                }
                
                jsonGroup.notify(queue: DispatchQueue.main) {
                    let news = VkNews(items: news, profiles: users, groups: groups)
                    completion?(news, nil)
                }
                
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
    
    func loadPartVKNews(startFrom: String, completion: ((VkNews?, Error?, String?) -> Void)? = nil) {
        let path = "/method/newsfeed.get"
        let parameters: Parameters = [
            "filters": "post,photo",
            "start_from": startFrom,
            "count": 30,
            "access_token": SessionApp.shared.token,
            "v": versionAPI
        ]
        let url = baseUrl + path
        
        VKService.sharedManager.request(url, method: .get, parameters: parameters).responseJSON(queue: .global(qos: .userInteractive)) { response in
            print(VKService.sharedManager.request(url, method: .get, parameters: parameters))
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var news = [News]()
                var users = [Owner]()
                var groups = [Owner]()
                var nextFrom = ""
                
                let jsonGroup = DispatchGroup()
                
                news = json["response"]["items"].arrayValue.map { News(json: $0) }
                users = json["response"]["profiles"].arrayValue.map { Owner(json: $0) }
                
                groups = json["response"]["groups"].arrayValue.map { Owner(json: $0) }
                nextFrom = json["response"]["next_from"].stringValue
                
                SessionApp.shared.nextFrom = nextFrom
                
                let res = VkNews(items: news, profiles: users, groups: groups)
                
                jsonGroup.notify(queue: DispatchQueue.main) {
                    completion?(res, nil, nextFrom)
                }
                
            case .failure(let error):
                completion?(nil, error, nil)
            }
        }
    }
    
}
