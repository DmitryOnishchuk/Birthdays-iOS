//
//  Loader.swift
//  MVP-Swift-Example
//
//  Created by Dmitry Onishchuk on 01.01.2022.
//  Copyright © 2022 Dmitry Onishchuk. All rights reserved.
//

import Foundation
import MBProgressHUD

class Loader {
    
    var hud: MBProgressHUD!
    weak var view: UIView!
    
    //static let shared = Loader()
    
    init(in view: UIView) {
        self.view = view
    }
    
    func show() {
        show(view: self.view)
    }
    
    func show(title: String) {
        show(view: self.view, title: title)
    }
    
    func show(view: UIView, title: String = "Загрузка") {
        hud?.removeFromSuperview()
        hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.animationType = .fade
        hud.mode = .indeterminate
        hud.isUserInteractionEnabled = false
        hud.label.text = title
        view.isUserInteractionEnabled = false
        self.view = view
    }
    
    func showProgress(progress:Float) {
        hud?.mode = .determinate
        hud?.progress = progress
    }
    
    func hide(animated: Bool = true) {
        hud?.hide(animated: animated)
        view.isUserInteractionEnabled = true
    }
}
