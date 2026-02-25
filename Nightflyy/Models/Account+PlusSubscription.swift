//
//  Account+PlusSubscription.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 2/25/26.
//

import Foundation

// MARK: - Plus Subscription Convenience

extension Account {
    
    var hasActiveSubscription: Bool {
        plusMember ?? false
    }
    
    var hasAvailableCredits: Bool {
        (plusCredits ?? 0) > 0
    }
    
    var isProvider: Bool {
        plusProvider ?? false
    }
    
}
