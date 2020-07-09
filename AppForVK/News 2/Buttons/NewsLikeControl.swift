//
//  NewsLikeControl.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 04/01/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import UIKit

class NewsLikeControl: UIControl {
    
    var temp = false {
        didSet {
            self.updateButton()
            self.sendActions(for: .valueChanged)
        }
    }
    
    var alreadyLike = false
    private var stackView: UIStackView!
    private var buttons: [UIButton] = []
    private var count = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        let buttonLike = UIButton(type: .system)
        buttonLike.setImage(UIImage(named: "HeartWhite.png"), for: .normal)
        buttonLike.setImage(UIImage(named: "Heart.png"), for: .selected)
        buttonLike.addTarget(self, action: #selector(tapLike(_:)), for: .touchUpInside)
        buttonLike.backgroundColor = UIColor.clear
        self.buttons.append(buttonLike)
        let buttonCount = UIButton(type: .system)
        buttonCount.setTitle(String(count), for: .normal)
        buttonCount.setTitleColor(UIColor.blue, for: .normal)
        buttonCount.setTitleColor(UIColor.red, for: .selected)
        self.buttons.append(buttonCount)
        
        stackView = UIStackView(arrangedSubviews: self.buttons)
        
        self.addSubview(stackView)
        
        stackView.distribution = .fillEqually
        
    }
    
    private func updateButton() {
        if alreadyLike == false {
            let buttonLike = buttons[0]
            buttonLike.isSelected = true
            count += 1
            let buttonCount = buttons[1]
            buttonCount.setTitle(String(count), for: .selected)
            buttonCount.isSelected = true
            self.alreadyLike = true
        } else {
            let buttonLike = buttons[0]
            buttonLike.isSelected = false
            count = count - 1
            let buttonCount = buttons[1]
            buttonCount.setTitle(String(count), for: .normal)
            buttonCount.isSelected = false
            self.alreadyLike = false
        }
        
    }
    
    @objc private func tapLike(_ sender: UIButton) {
        self.updateButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }

}
