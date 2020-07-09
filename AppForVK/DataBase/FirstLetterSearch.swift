//
//  FirstLetterSearch.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 30/01/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import Foundation

class FirstLetterSearch {
    
    static func isMatched (searchBase: String, searchString: String) -> Bool {
        var isMatched: Bool = false
        var wordsInSearchBaseCount: Int = 1
        var wordsArray: [String] = []
        let searchBaseLowercased = searchBase.lowercased()
        let searchStringLowercased = searchString.lowercased()
        
        //create an array of words to compare the search to
        if searchBaseLowercased.contains(" ") {
            var word: [Character] = []
            for char in searchBaseLowercased {
                word.append(char)
                if (char == " ") {
                    wordsInSearchBaseCount += 1
                    wordsArray.append(String(word))
                    word = []
                }
            }
            wordsArray.append(String(word))
        }
        else {
            //only one word in a string
            wordsArray.append(searchBaseLowercased)
        }
        for word in wordsArray {
            isMatched = false
            guard (word.count >= searchStringLowercased.count) else { return false}
            let searchBaseSubstring = word[..<searchStringLowercased.count]
            if (searchStringLowercased == String(searchBaseSubstring)) {
                isMatched = true
                break
            } else { isMatched = false }
        }
        return isMatched
    }
}
