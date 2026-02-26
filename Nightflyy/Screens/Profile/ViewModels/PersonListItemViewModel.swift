//
//  PersonListItemViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/9/25.
//

import Foundation

@Observable @MainActor
class PersonListItemViewModel: Hashable {
    
    nonisolated let id: String
    
    nonisolated static func == (lhs: PersonListItemViewModel, rhs: PersonListItemViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var account: Account
    
    var isPlusMember: Bool {
        account.hasActiveSubscription
    }
    
    var isPlusProvider: Bool {
        account.isProvider
    }
    
    init(account: Account) {
        self.id = account.uid
        self.account = account
    }

    func navigateToProfile() {
        let viewModel = ProfileViewModel(account: account)
        Router.shared.navigateTo(.Profile(viewModel))
    }
    
}
