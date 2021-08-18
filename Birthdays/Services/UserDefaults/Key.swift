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
    static let isFirstStart: Key                = "IS_FIRST_START"
    static let currentLanguage: Key             = "CURRENT_LANGUAGE"
    static let notificationTime: Key            = "NOTIFICATION_TIME_KEY"
    static let ageType: Key                     = "AGE_TYPE_KEY"
    static let currentThemeID: Key              = "THEME_KEY"
    static let notificationEnabled: Key         = "NOTIFICATION_ENABLED"
    static let notificationTimeEvent0: Key      = "NOTIFICATION_TIME_EVENT_KEY_0"
    static let notificationTimeEvent1: Key      = "NOTIFICATION_TIME_EVENT_KEY_1"
    static let notificationTimeEvent2: Key      = "NOTIFICATION_TIME_EVENT_KEY_2"
}
