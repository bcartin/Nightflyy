//
//  VenueListItemViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/28/25.
//

import Foundation

@Observable
class VenueListItemViewModel: NSObject {
    
    var venue: Account
    
    var isPlusVenue: Bool {
        venue.plusVenue ?? false
    }
    
    init(venue: Account) {
        self.venue = venue
        super.init()
    }

    func navigateToProfile() {
        let viewModel = ProfileViewModel(account: venue)
        Router.shared.navigateTo(.Profile(viewModel))
    }
    
}
