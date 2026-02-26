//
//  Account+VenueProfile.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 2/25/26.
//

import Foundation

// MARK: - Venue Profile Convenience

extension Account {
    
    var isVenue: Bool {
        accountType == .venue
    }
    
    var hasBusinessContact: Bool {
        (businessEmail != nil && businessEmail != "") || (website != nil && website != "")
    }
    
    var hasVenuePerk: Bool {
        perkName != nil && perkDetails != nil
    }
    
}
