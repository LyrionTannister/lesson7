//
//  Session.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 05/02/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import Foundation

class SessionApp {
    private init() { }
    
    public static let shared = SessionApp()
    
    var token: String = ""
    var userId: Int = 0
    var nextFrom: String = ""
}
