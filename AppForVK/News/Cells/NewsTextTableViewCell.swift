//
//  NewsTextTableViewCell.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 31/03/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import Foundation
import UIKit

class NewsTextTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "NewsTextCell"
    
    var expandAction: ((UIButton) -> Void)?

    @IBOutlet weak var newsText: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    
    @IBAction func expand(_ sender: UIButton) {
        expandAction?(sender)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
