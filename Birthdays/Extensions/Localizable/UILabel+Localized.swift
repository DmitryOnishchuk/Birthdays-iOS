//
//  Label+Localized.swift
//  Lubimoe Taxi
//
//  Created by Yurii Chudnovets on 09.05.2020.
//  Copyright © 2020 Lubimoe Taxi. All rights reserved.
//

import UIKit

extension UILabel {
    
    @IBInspectable var localizableText: String {
        set(value) {
            self.text = value.localized
        }
        get {
            return self.text ?? ""
        }
    }
    
}
