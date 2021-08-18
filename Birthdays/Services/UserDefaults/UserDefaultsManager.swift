//
//  Storage.swift
//  Birthdays
//
//  Created by Dmitry Onishchuk on 13.06.2021.
//  Copyright © 2021 Dmitry Onishchuk. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    
    static var shared = UserDefaultsManager()
    
    private init() {}
    
    @UserDefault(.isFirstStart, defaultValue: true)
    var isFirstStart: Bool
    
    @UserDefault(.currentLanguage, defaultValue: getDefaultLanguage())
    var currentLanguage: String
    
    @UserDefault(.ageType, defaultValue: AgeSettingsEnum.upcoming.rawValue)
    var ageType: String
    
    @UserDefault(.currentThemeID, defaultValue: 0)
    var currentThemeID: Int

    @UserDefault(.notificationEnabled, defaultValue: true)
    var notificationEnabled: Bool
    
    @UserDefault(.notificationTimeEvent0, defaultValue: "0,10:00")
    var notificationTimeEvent0: String
    
    @UserDefault(.notificationTimeEvent1, defaultValue: "3,10:00")
    var notificationTimeEvent1: String
    
    @UserDefault(.notificationTimeEvent2, defaultValue: "-1,10:00")
    var notificationTimeEvent2: String
    
    @UserDefault(.lastNotificationPoolUpdateDateTime, defaultValue: Date())
    var lastNotificationPoolUpdateDateTime: Date
}

private func getDefaultLanguage() -> String{
    
    var resDefault = "en"
    
    let currentLanguageOfSystem = Locale.current.languageCode
    
    if currentLanguageOfSystem == "en" ||
        currentLanguageOfSystem == "ru" {
        resDefault = currentLanguageOfSystem ?? resDefault
    }
    return resDefault
    
}
