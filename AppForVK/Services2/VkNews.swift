//
//  VkNews.swift
//  AppForVK
//
//  Created by Mad Brains on 01.07.2020.
//  Copyright © 2020 Семериков Михаил. All rights reserved.
//

import Foundation

class VkNews {
    
    var items: [News]
    var profiles: [Owner]
    var groups: [Owner]
    
    init(items: [News], profiles: [Owner], groups: [Owner]) {
        self.items = items
        self.profiles = profiles
        self.groups = groups
    }
    
}
