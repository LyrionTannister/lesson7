//
//  NewsImageTableViewCell.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 31/03/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import UIKit

class NewsImageTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "NewsImageCell"

    @IBOutlet weak var newsImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
