//
//  NotificationSettingsModuleBuilder.swift
//  Birthdays
//
//  Created by Dmitry Onishchuk on 01.07.2021.
//  Copyright © 2021 Dmitry Onishchuk. All rights reserved.
//

import UIKit

struct NotificationSettingsModuleBuilder {
    
    func create() -> UITableViewController {
        let notificationSettings = UIStoryboard(name: "NotificationSettings", bundle: nil).instantiateViewController(withIdentifier: String(describing: NotificationSettingsTableVC.self)) as! NotificationSettingsTableVC
        return notificationSettings
    }
    
}
