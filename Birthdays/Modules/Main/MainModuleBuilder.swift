//
//  MainModuleBuilder.swift
//  Birthdays
//
//  Created by Dmitry Onishchuk on 07.07.2021.
//  Copyright © 2021 Dmitry Onishchuk. All rights reserved.
//

import UIKit

struct MainModuleBuilder {
    
    func create() -> UINavigationController {
        let mainNC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainNC") as! UINavigationController
        let mainVC = mainNC.topViewController as! MainVC
        return mainNC
    }
    
}
