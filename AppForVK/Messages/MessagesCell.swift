//
//  MessagesCell.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 22/04/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import UIKit

class MessagesCell: UITableViewCell {
    
    @IBOutlet weak var friendPhoto: UIImageView!
    @IBOutlet weak var friendFullName: UILabel!
    @IBOutlet weak var myLittlePhoto: UIImageView!
    @IBOutlet weak var lastMessages: UILabel!
    @IBOutlet weak var messageTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
