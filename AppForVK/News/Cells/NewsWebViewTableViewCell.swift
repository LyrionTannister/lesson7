//
//  NewsWebViewTableViewCell.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 07/04/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import UIKit
import WebKit

class NewsWebViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var webView: WKWebView!
    
    static let reuseIdentifier = "NewsWebViewCell"
    //public var player:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        let myURL = URL(string:player)
//        let myRequest = URLRequest(url: myURL!)
//        webView.load(myRequest)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(player: String) {
        let myURL = URL(string:player)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
}
