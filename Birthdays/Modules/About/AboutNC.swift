//
//  VoteNC.swift
//  CallTaxi
//
//  Created by yura on 7/17/19.
//  Copyright © 2019 Lubimoe Taxi. All rights reserved.
//

import UIKit

class AboutNC: NiblessNavigationController {
    
    override init() {
        super.init()
        
        setupPresentationStyle()
    }
    
    fileprivate func setupPresentationStyle() {
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
}

extension AboutNC: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimationController()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentAnimationController()
    }
}
