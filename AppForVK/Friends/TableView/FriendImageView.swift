//
//  FriendImageView.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 12/01/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import UIKit

@IBDesignable class FriendImageView: UIImageView {
    
    private var cornerRadius: CGFloat = 18
    private var masksToBounds: Bool = true
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    var layerImage: CAShapeLayer {
        return self.layer as! CAShapeLayer
    }
    
    override func layoutSubviews() {
        (layer as! CAShapeLayer).cornerRadius = cornerRadius
        (layer as! CAShapeLayer).masksToBounds = masksToBounds
    }
}
