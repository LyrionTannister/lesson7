//
//  NewsRepostHeaderTableViewCell.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 06/04/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import UIKit

class NewsRepostHeaderTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "NewsRepostHeaderCell"
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var newsDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.clipsToBounds = true
    }
    
}
