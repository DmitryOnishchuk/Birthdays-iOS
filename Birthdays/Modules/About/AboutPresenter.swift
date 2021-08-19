//
//  VotePresenter.swift
//  CallTaxi
//
//  Created by yura on 7/15/19.
//  Copyright © 2019 Lubimoe Taxi. All rights reserved.
//

import Foundation

protocol AboutPresenterProtocol {
    func cancelButtonPressed()
    func repeatButtonPressed()
}

class AboutPresenter: AboutPresenterProtocol {

    unowned let view: NoNetworkViewProtocol
    let router: AboutRouterProtocol
    
    init(view: NoNetworkViewProtocol, router: AboutRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func cancelButtonPressed() {
        router.close()
    }
    
    func repeatButtonPressed() {
        print("REPEAT")
    }
    
}
