//
//  NewsLikeControl.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 04/01/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import UIKit

class NewsShareControl: UIControl {
    
    var temp = false {
        didSet {
            self.updateButton()
            self.sendActions(for: .valueChanged)
        }
    }
    
    //var alreadyLike = false
    private var stackView: UIStackView!
    private var buttons: [UIButton] = []
    private var count = 0
    private let buttonLike = UIButton(type: .system)
    private let buttonCount = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        buttonLike.setImage(UIImage(named: "share_outline_24.png"), for: .normal)
        buttonLike.addTarget(self, action: #selector(tapLike(_:)), for: .touchUpInside)
        self.buttons.append(buttonLike)
        buttonCount.setTitle(String(count), for: .normal)
        buttonCount.setTitleColor(UIColor.blue, for: .normal)
        buttonCount.setTitleColor(UIColor.blue, for: .selected)
        self.buttons.append(buttonCount)
        stackView = UIStackView(arrangedSubviews: self.buttons)
        self.addSubview(stackView)
        stackView.distribution = .fillEqually
    }
    
    private func updateButton() {
            let buttonLike = buttons[0]
            buttonLike.isSelected = true
            count += 1
            let buttonCount = buttons[1]
            buttonCount.setTitle(String(count), for: .selected)
            buttonCount.isSelected = true
    }
    
    @objc private func tapLike(_ sender: UIButton) {
        self.updateButton()
    }
    
    func updateCount(share: Int) {
        count = share
        buttonCount.setTitle(String(count), for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }

}
