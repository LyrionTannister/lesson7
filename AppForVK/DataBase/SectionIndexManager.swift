//
//  SectionIndexManager.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 30/01/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import Foundation

class SectionIndexManager {
    
    static func getOrderedIndexArray(array: [User]) -> [Character] {
        var indexArray: [Character] = []
        var indexSet = Set<Character>()
        for item in array {
            if item.lastName != "" {
                let firstLetter = item.lastName[0]
                indexSet.insert(firstLetter)
            }
        }
        for char in indexSet{
            indexArray.append(char)
        }
        indexArray.sort()
        return indexArray
    }
    
    static func getFriendIndexDictionary(array: [User]) -> [Character: [User]] {
        var friendIndexDictionary: [Character: [User]] = [:]
        
        for item in array {
            if item.lastName != "" {
                let firstLetter = item.lastName[0]
                if (friendIndexDictionary.keys.contains(firstLetter)) {
                    friendIndexDictionary[firstLetter]?.append(item)
                } else {
                    friendIndexDictionary[firstLetter] = [item]
                }
            }
        }
        return friendIndexDictionary
    }
}
