//
//  StringExtensions.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 30/01/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import Foundation
import UIKit

extension String {
    subscript(index: Int) -> Character {
        let startIndex = self.index(self.startIndex, offsetBy: index)
        return self[startIndex]
    }
    
    subscript(range: NSRange) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: range.location)
        let endIndex = self.index(startIndex, offsetBy: range.length)
        return String(self[startIndex..<endIndex])
    }

    subscript(value: CountableClosedRange<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)...index(at: value.upperBound)]
        }
    }
    
    subscript(value: CountableRange<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)..<index(at: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeUpTo<Int>) -> Substring {
        get {
            return self[..<index(at: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeThrough<Int>) -> Substring {
        get {
            return self[...index(at: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeFrom<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)...]
        }
    }
    
    func index(at offset: Int) -> String.Index {
        return index(startIndex, offsetBy: offset)
    }
    
    func attributedString(font: UIFont, lineSpacing: CGFloat, alignment: NSTextAlignment = .left) -> NSAttributedString! {
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        paragraphStyle.paragraphSpacing = 0
        return NSAttributedString(string: self, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
}
