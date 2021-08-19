//
//  UIButton+Localized.swift
//  Lubimoe Taxi
//
//  Created by Yurii Chudnovets on 09.05.2020.
//  Copyright © 2020 Lubimoe Taxi. All rights reserved.
//

import UIKit

extension UIButton {
    
    @IBInspectable var localizableTitle: String {
        set(value) {
            self.setTitle(value.localized, for: .normal)
        }
        get {
            return titleLabel?.text ?? ""
        }
    }
    
}
