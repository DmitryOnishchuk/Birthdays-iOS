//
//  LanguageSettingsModuleBuilder.swift
//  Birthdays
//
//  Created by Dmitry Onishchuk on 01.07.2021.
//  Copyright © 2021 Dmitry Onishchuk. All rights reserved.
//

import UIKit

struct LanguageSettingsModuleBuilder {
    
    func create() -> UITableViewController {
        let languageSettings = UIStoryboard(name: "LanguageSettings", bundle: nil).instantiateViewController(withIdentifier: String(describing: LanguageSettingsTableVC.self)) as! LanguageSettingsTableVC
        return languageSettings
    }
    
}
