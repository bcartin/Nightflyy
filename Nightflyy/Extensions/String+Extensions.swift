//
//  String+Extensions.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/10/25.
//

import Foundation

extension String {
    
    func dateValue(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}
