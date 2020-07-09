//
//  TransitionManager.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 31/01/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import UIKit

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        let duration = self.transitionDuration(using: transitionContext)
        let scale = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        toView.transform = scale
        
        container.addSubview(toView)
        container.addSubview(fromView)
    
        UIView.animate(withDuration: duration, animations: {
            toView.transform = CGAffineTransform.identity }, completion: {(finished) -> Void in
                transitionContext.completeTransition(true)
        })
        UIView.animate(withDuration: duration, animations: { () -> Void in
            toView.transform = CGAffineTransform.identity
        }, completion: { (finished) -> Void in
            transitionContext.completeTransition(true)
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}
