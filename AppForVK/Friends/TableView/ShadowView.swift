//
//  ShadowView.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 12/01/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    
    private var cornerRadius: CGFloat = 18
    private var shadowColor: UIColor = UIColor.black
    private var shadowOpacity: Float = 0.5
    private var shadowRadius: CGFloat = 6.0
    /*@IBInspectable var shadowRadius: CGFloat = 6 {
        didSet {
            setNeedsDisplay()
        }
    }*/
    
    private var shadowOffset: CGSize = CGSize.zero
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    override func layoutSubviews() {
        (layer as! CAShapeLayer).cornerRadius = cornerRadius
        (layer as! CAShapeLayer).shadowColor = shadowColor.cgColor
        (layer as! CAShapeLayer).shadowOpacity = shadowOpacity
        (layer as! CAShapeLayer).shadowRadius = shadowRadius
        (layer as! CAShapeLayer).shadowOffset = shadowOffset
    }
}
