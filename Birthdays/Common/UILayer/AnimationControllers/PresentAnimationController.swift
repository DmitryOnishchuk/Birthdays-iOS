//
//  PresentAnimationController.swift
//  CallTaxi
//
//  Created by yura on 7/15/19.
//  Copyright © 2019 Lubimoe Taxi. All rights reserved.
//

import UIKit

class PresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let overflowView: VisualEffectView = {
        let v = VisualEffectView()
        v.tint(.clear, blurRadius: 8)
        return v
    }()
    
    let animationDuration: TimeInterval
    
    init(animationDuration: TimeInterval = 0.25) {
        self.animationDuration = animationDuration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else { return }
        let conteinerView = transitionContext.containerView
        
        toVC.view.frame = fromVC.view.frame// CGRect(origin: CGPoint(x: 0, y: 0), size: fromVC.view.bounds.size)
        conteinerView.addSubview(toVC.view)
        overflowView.tag = -1
        conteinerView.insertSubview(overflowView, at: 0)
        overflowView.fillSuperview()
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            self.overflowView.alpha = 1
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
}
