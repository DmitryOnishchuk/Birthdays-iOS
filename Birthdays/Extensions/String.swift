//
//  String.swift
//  Birthdays
//
//  Created by Dima on 15.04.2021.
//

import UIKit

extension String {
    var localized: String{
        return NSLocalizedString(self, comment: "")
    }
    
    func toDate () -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: self)
    }
    
    func toURL() -> URL? {
        return URL(string: self)
    }
    
}
