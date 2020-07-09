//
//  NewsFooterTableViewCell.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 31/03/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import UIKit

class NewsFooterTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "NewsFooterCell"
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var iconCommentWidth: NSLayoutConstraint!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var iconViews: UIImageView!
    @IBOutlet weak var viewsLabel: UILabel!
    
    var delegateButton: CellForButtonsDelegate?
    var indexPathCell: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func tapLikeButton(_ sender: UIButton) {
        delegateButton?.didTapCompleteButton(indexPath: indexPathCell!)
        
        if likeButton.currentImage == UIImage(named: "HeartWhite") {
            likeButton.setImage(UIImage(named: "Heart"), for: .normal)
            likeLabel.textColor = UIColor.vkRed
            
            if let likesTest = Int(likeLabel.text!) {
                if likesTest < 1000 {
                    likeLabel.text = String(Int(likeLabel.text!)! + 1)
                }
            }
        } else {
            likeButton.setImage(UIImage(named: "HeartWhite"), for: .normal)
            likeLabel.textColor = UIColor.vk_color
            if let likesTest = Int(likeLabel.text!) {
                if likesTest < 1000 {
                    likeLabel.text = String(Int(likeLabel.text!)! - 1)
                }
            }
        }
    }
    
}
