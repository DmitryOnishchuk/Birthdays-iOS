//
//  AgeTypeSettingsModuleBuilder.swift
//  Birthdays
//
//  Created by Dmitry Onishchuk on 01.07.2021.
//  Copyright © 2021 Dmitry Onishchuk. All rights reserved.
//

import Foundation
import UIKit

struct AgeTypeSettingsModuleBuilder {
    
    func create() -> UITableViewController {
        let mainSettings = UIStoryboard(name: "AgeTypeSettings", bundle: nil).instantiateViewController(withIdentifier: "AgeTypeSettingsTableVC") as! AgeTypeSettingsTableVC
        return mainSettings
    }
    
}
