//
//  CustomTabbar.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 27/04/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import UIKit

class CustomTabbar: UITabBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initTabbarItem()
    }
    
    private func initTabbarItem() {
        let item1: UITabBarItem = UITabBarItem(title: "Друзья", image: nil, tag: 0)
        let item2: UITabBarItem = UITabBarItem(title: "Группы", image: nil, tag: 1)
        let item3: UITabBarItem = UITabBarItem(title: "Новости", image: nil, tag: 2)
        let item4: UITabBarItem = UITabBarItem(title: "ХУЙ", image: nil, tag: 3)
        self.setItems([item1, item2, item3, item4], animated: true)
    }
    
}
