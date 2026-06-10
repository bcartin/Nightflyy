//
//  Account+VenueProfile.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 2/25/26.
//

import Foundation
import CoreLocation

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
    
    func distance(to location: CLLocation) -> CLLocationDistance {
        return location.distance(from: self.getCLLocation())
    }
    
    func getCLLocation() -> CLLocation {
        return CLLocation(latitude: self.location?.latitude ?? 0, longitude: self.location?.longitude ?? 0)
    }
    
}
