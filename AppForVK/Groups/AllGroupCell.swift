//
//  AllGroupCell.swift
//  AppForVK
//
//  Created by Семериков Михаил on 26.12.2018.
//  Copyright © 2018 Семериков Михаил. All rights reserved.
//

import UIKit

class AllGroupCell: UITableViewCell {
    
    @IBOutlet weak var allGroupName: UILabel!
    @IBOutlet weak var allGroupImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
