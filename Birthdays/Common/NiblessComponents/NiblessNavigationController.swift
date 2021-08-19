//
//  NiblessNavigationController.swift
//  CallTaxi
//
//  Created by yura on 7/17/19.
//  Copyright © 2019 Lubimoe Taxi. All rights reserved.
//

import UIKit

class NiblessNavigationController: UINavigationController {
    
    // MARK: - Methods
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable,
    message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection."
    )
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*, unavailable,
    message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection."
    )
    required init?(coder aDecoder: NSCoder) {
        fatalError("Loading this view controller from a nib is unsupported in favor of initializer dependency injection.")
    }
}
