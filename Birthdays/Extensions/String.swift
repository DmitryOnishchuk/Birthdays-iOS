//
//  String.swift
//  Birthdays
//
//  Created by Dima on 15.04.2021.
//

import UIKit

extension String {
    
    func toDate () -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: self)
    }
    
    func toURL() -> URL? {
        return URL(string: self)
    }
    
}
