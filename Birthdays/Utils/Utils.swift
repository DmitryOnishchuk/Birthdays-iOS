//
//  Utils.swift
//  Birthdays
//
//  Created by Dmitry Onishchuk on 12.08.2021.
//  Copyright © 2021 Dmitry Onishchuk. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    
    static func openURLLink(link: String) {
        if let url = link.toURL() {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    static func openEmail(email: String) {
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    static func getAppName() -> String{
        return "APPNAME".localized
    }
    
    static func getAppVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }    
}
