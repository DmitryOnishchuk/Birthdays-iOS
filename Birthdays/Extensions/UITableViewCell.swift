//
//  UITableViewCell.swift
//  Birthdays
//
//  Created by Dmitry Onishchuk on 13.08.2021.
//  Copyright © 2021 Dmitry Onishchuk. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    func enable(on: Bool) {
        for view in contentView.subviews {
            self.isUserInteractionEnabled = on
            view.isUserInteractionEnabled = on
            view.alpha = on ? 1 : 0.5
        }
    }
}
