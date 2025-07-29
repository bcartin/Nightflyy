//
//  SortFilter+Extensions.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/13/24.
//

import Foundation

extension [Event] {
    
    func sorted() -> [Event] {
        return self.sorted{$0.startDate ?? Date() < $1.startDate ?? Date()}
    }
    
    func removingPastEvents() -> [Event] {
        return self.filter({$0.endDate ?? Date() > Date()})
    }
    
    func onlyPastEvents() -> [Event] {
        return self.filter({$0.endDate ?? Date() < Date()})
    }
    
}
