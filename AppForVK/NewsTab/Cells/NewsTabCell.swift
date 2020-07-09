//
//  NewsTabCell.swift
//  AppForVK
//
//  Created by Mad Brains on 01.07.2020.
//  Copyright © 2020 Семериков Михаил. All rights reserved.
//

import UIKit

class NewsTabCell: UITableViewCell {
    
    @IBOutlet weak var newsTextLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var viewedLabel: UILabel!
    @IBOutlet weak var ownerImageView: UIImageView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    func configure(with news: News?, owner: Owner?, photoHeight: CGFloat) {
        guard let uNews = news, let uOwner = owner else {
            return
        }
    
        let userName = uOwner.userName.trimmingCharacters(in: .whitespacesAndNewlines)
        let groupName = uOwner.groupName.trimmingCharacters(in: .whitespacesAndNewlines)
            
        newsTitleLabel.text = userName.isEmpty ? groupName : userName
    
        ownerImageView.kf.setImage(with: URL(string: uOwner.ownerPhoto))
    
        dateLabel.text = Date(timeIntervalSince1970: uNews.titlePostTime).timeAgo(numericDates: false)
        
        newsTextLabel.text = uNews.postText
        
        newsImageView.kf.setImage(with: URL(string: uNews.attachments_typePhoto))
        
        heightConstraint.constant = photoHeight
    }
    
}
