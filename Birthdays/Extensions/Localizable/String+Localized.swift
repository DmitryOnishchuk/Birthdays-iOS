//
//  String+Localized.swift
//  Lubimoe Taxi
//
//  Created by Yurii Chudnovets on 09.05.2020.
//  Copyright © 2020 Lubimoe Taxi. All rights reserved.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    } 
}
