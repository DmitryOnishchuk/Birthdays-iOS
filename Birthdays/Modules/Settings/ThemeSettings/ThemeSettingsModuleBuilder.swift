//
//  ThemeSettingsModuleBuilder.swift
//  Birthdays
//
//  Created by Dmitry Onishchuk on 01.07.2021.
//  Copyright © 2021 Dmitry Onishchuk. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
struct ThemeSettingsModuleBuilder {
    
    func create() -> UITableViewController {
        let themeSettings = UIStoryboard(name: "ThemeSettings", bundle: nil).instantiateViewController(withIdentifier: String(describing: ThemeSettingsTableVC.self)) as! ThemeSettingsTableVC
        return themeSettings
    }
    
}
