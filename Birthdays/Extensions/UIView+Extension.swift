//
//  UIView+Extension.swift
//  Birthdays
//
//  Created by Dmitry Onishchuk on 19.08.2021.
//  Copyright © 2021 Dmitry Onishchuk. All rights reserved.
//

import UIKit

extension UIView {
    
    func shadow(color: UIColor = UIColor.black,
                offset: CGSize = CGSize(width: 0, height: 1),
                opacity: Float = 0.2,
                radius: CGFloat = 2){
        self.layer.shadowRadius = radius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
    }
    
    func removeShadow() {
        self.layer.shadowColor = nil
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0
        self.layer.shadowRadius = 0
    }
    
}
