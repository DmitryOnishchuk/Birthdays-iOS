//
//  UserDefault.swift
//  Birthdays
//
//  Created by Dmitry Onishchuk on 13.06.2021.
//  Copyright © 2021 Dmitry Onishchuk. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefault<T: PropertyListValue> {
    let key: Key
    let defaultValue: T
    var userDefaults: UserDefaults
    
    init(_ key: Key, defaultValue: T, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    var wrappedValue: T {
        get { userDefaults.value(forKey: key.rawValue) as? T ?? defaultValue }
        set { userDefaults.set(newValue, forKey: key.rawValue) }
    }
}

@propertyWrapper
struct UserDefaultNillable<T: PropertyListValue> {
    let key: Key
    var userDefaults: UserDefaults
    
    init(_ key: Key, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.userDefaults = userDefaults
    }

    var wrappedValue: T? {
        get { userDefaults.value(forKey: key.rawValue) as? T }
        set { userDefaults.set(newValue, forKey: key.rawValue) }
    }
}

@propertyWrapper
struct UserDefaultURL {
    let key: Key
    var userDefaults: UserDefaults
    
    init(_ key: Key, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.userDefaults = userDefaults
    }

    var wrappedValue: URL? {
        get { userDefaults.url(forKey: key.rawValue) }
        set { userDefaults.set(newValue, forKey: key.rawValue) }
    }
}
