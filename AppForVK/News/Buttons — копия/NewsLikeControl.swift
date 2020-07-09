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
    
    //private var likeButton = HeartButton()
    //private let likesLabel = UILabel()
    
    private var alreadyLike = false
    private var stackView: UIStackView!
    private var buttons: [UIButton] = []
    private var count: Int = 0
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
        buttonLike.setImage(UIImage(named: "HeartWhite.png"), for: .normal)
        buttonLike.setImage(UIImage(named: "Heart.png"), for: .selected)
        buttonLike.addTarget(self, action: #selector(tapLike(_:)), for: .touchUpInside)
        buttonLike.backgroundColor = UIColor.clear
        self.buttons.append(buttonLike)
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
            buttonCount.isSelected = true
            self.alreadyLike = true
            UIView.transition(with: buttonCount, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                buttonCount.setTitle(String(self.count), for: .selected)})
        } else {
            let buttonLike = buttons[0]
            buttonLike.isSelected = false
            count = count - 1
            let buttonCount = buttons[1]
            buttonCount.isSelected = false
            self.alreadyLike = false
            UIView.transition(with: buttonCount, duration: 0.5, options: .transitionFlipFromRight, animations: {
                buttonCount.setTitle(String(self.count), for: .normal)})
        }
        
    }
    
    @objc private func tapLike(_ sender: UIButton) {
        self.updateButton()
    }
    
    func updateCount(likes: Int) {
        count = likes
        buttonCount.setTitle(String(count), for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }

}
