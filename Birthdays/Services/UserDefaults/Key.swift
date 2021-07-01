//
//  Key.swift
//  Birthdays
//
//  Created by Dmitry Onishchuk on 13.06.2021.
//  Copyright © 2021 Dmitry Onishchuk. All rights reserved.
//

import Foundation

struct Key: RawRepresentable {
    let rawValue: String
}

extension Key: ExpressibleByStringLiteral {
    init(stringLiteral: String) {
        rawValue = stringLiteral
    }
}

extension Key {
    static let currentLanguage: Key             = "current_language"
    static let notificationTime: Key            = "NOTIFICATION_TIME_KEY"
    static let ageType: Key                     = "AGE_TYPE_KEY"
    static let currentThemeID: Key              = "THEME_KEY"
}
