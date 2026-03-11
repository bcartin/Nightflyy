//
//  VenueListItemViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/28/25.
//

import Foundation

@Observable @MainActor
class VenueListItemViewModel: Hashable {
    
    nonisolated let id: String
    
    nonisolated static func == (lhs: VenueListItemViewModel, rhs: VenueListItemViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var venue: Account
    
    var isPlusVenue: Bool {
        venue.isProvider
    }
    
    init(venue: Account) {
        self.id = venue.uid
        self.venue = venue
    }

    func navigateToProfile() {
        let viewModel = ProfileViewModel(account: venue)
        Router.shared.navigateTo(.Profile(viewModel))
    }
    
}
