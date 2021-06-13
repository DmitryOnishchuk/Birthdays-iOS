//
//  Date.swift
//  Birthdays
//
//  Created by Dima on 15.04.2021.
//

import UIKit

extension Date {
    func toString () -> String? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.string(from: self)
    }
}

extension DateFormatter {
    convenience init (format: String) {
        self.init()
        dateFormat = format
        locale = Locale.current
    }
}
