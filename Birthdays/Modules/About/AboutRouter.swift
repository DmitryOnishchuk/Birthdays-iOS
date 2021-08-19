//
//  VoteRouter.swift
//  CallTaxi
//
//  Created by yura on 7/16/19.
//  Copyright © 2019 Lubimoe Taxi. All rights reserved.
//

import UIKit

protocol AboutRouterProtocol {
    func close()
}

class AboutRouter: AboutRouterProtocol {

    unowned let vc: UIViewController
    
    init(vc: UIViewController) {
        self.vc = vc
    }

    func close() {
        vc.dismiss(animated: true, completion: nil)
    }
}
