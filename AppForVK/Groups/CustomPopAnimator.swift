//
//  CustomPopAnimator.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 30/01/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import UIKit

final class CustomPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration (using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition (using transitionContext: UIViewControllerContextTransitioning) {

        let container = transitionContext.containerView
        let source = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let destination = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        let duration = self.transitionDuration(using: transitionContext)
        
        destination.setAnchorPoint(CGPoint(x: 1, y: 0))
        source.setAnchorPoint(CGPoint(x: 1, y: 0))
        destination.transform = CGAffineTransform(rotationAngle: .pi/2)
        
        container.addSubview(destination)
        container.addSubview(source)
        
        UIView.animate(withDuration: duration, animations: {
            source.transform = CGAffineTransform(rotationAngle: -.pi/2)
            destination.transform = CGAffineTransform.identity
        }, completion: { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.transform = .identity
            }
            transitionContext.completeTransition(finished &&
                !transitionContext.transitionWasCancelled)
        })
    }
}

