//
//  Storage.swift
//  Birthdays
//
//  Created by Dmitry Onishchuk on 13.06.2021.
//  Copyright © 2021 Dmitry Onishchuk. All rights reserved.
//

import Foundation

final class UserDefaultsManager {
    
    @UserDefault("IS_FIRST_START", defaultValue: true) var isFirstStart: Bool!
    
    @UserDefault("CURRENT_LANGUAGE", defaultValue: getDefaultLanguage()) var currentLanguage: String!
    
    @UserDefault("AGE_TYPE_KEY", defaultValue: AgeSettingsEnum.upcoming.rawValue) var ageType: String!
    
    @UserDefault("THEME_KEY", defaultValue: 0) var currentThemeID: Int!

    @UserDefault("NOTIFICATION_ENABLED", defaultValue: true) var notificationEnabled: Bool!
    
    @UserDefault("NOTIFICATION_TIME_EVENT_KEY_0", defaultValue: "0,10:00") var notificationTimeEvent0: String!
    
    @UserDefault("NOTIFICATION_TIME_EVENT_KEY_1", defaultValue: "3,10:00") var notificationTimeEvent1: String!
    
    @UserDefault("NOTIFICATION_TIME_EVENT_KEY_2", defaultValue: "-1,10:00") var notificationTimeEvent2: String!
    
    @UserDefault("NOTIFICATION_POOL_UPDATE_TIME", defaultValue: Date()) var lastNotificationPoolUpdateDateTime: Date!
    
}

extension UserDefaultsManager {
    
    static private func getDefaultLanguage() -> String{
        
        var resDefault = "en"
        let currentLanguageOfSystem = Locale.current.languageCode
        
        if currentLanguageOfSystem == "en" || currentLanguageOfSystem == "ru" {
            resDefault = currentLanguageOfSystem ?? resDefault
        }
        return resDefault
        
    }
    
}
