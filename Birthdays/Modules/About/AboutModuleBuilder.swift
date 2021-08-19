//
//  VoteModuleBuilder.swift
//  CallTaxi
//
//  Created by yura on 7/15/19.
//  Copyright © 2019 Lubimoe Taxi. All rights reserved.
//

import UIKit

class AboutModuleBuilder {
    
    func create() -> UIViewController {
        let vc = AboutVC()
        let router = AboutRouter(vc: vc)
        let presenter = AboutPresenter(view: vc, router: router)
        vc.presenter = presenter
        let nc = AboutNC()
        nc.viewControllers = [vc]
        nc.view.backgroundColor = .clear
        return nc
    }
    
}
