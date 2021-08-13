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
    
    @UserDefault(.currentLanguage, defaultValue: getDefaultLanguage())
    var currentLanguage: String
    
   // @UserDefault(.notificationTime, defaultValue: "10:00")
   // var notificationTime: String
    
    
    @UserDefault(.notificationEnabled, defaultValue: true)
    var notificationEnabled: Bool
    
    @UserDefault(.ageType, defaultValue: AgeSettingsEnum.upcoming.rawValue)
    var ageType: String
    
    @UserDefault(.currentThemeID, defaultValue: 0)
    var currentThemeID: Int
    
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
