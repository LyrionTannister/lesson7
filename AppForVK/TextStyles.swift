//
//  TextStyles.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 28/04/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import UIKit

struct TextStyles {
    static let cellControlColoredStyle: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 13),
        .foregroundColor: UIColor.vkRed
    ]
    
    static let usernameStyle: [NSAttributedString.Key: Any] = [
        .font: UIFont.boldSystemFont(ofSize: 17),
        .foregroundColor: UIColor.vk_color
    ]
    
    static let timeStyle: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 14),
        .foregroundColor: UIColor.lightGray
    ]
    
    static let postStyle: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 15),
        .foregroundColor: UIColor.black
    ]
    
    static let postLinkStyle: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 15),
        .foregroundColor: UIColor.vkBlue,
        .underlineStyle: NSUnderlineStyle.single.rawValue
    ]
    
    static let cellControlStyle: [NSAttributedString.Key: Any] = [
        .font : UIFont.systemFont(ofSize: 13),
        .foregroundColor: UIColor.vk_color
    ]
}
