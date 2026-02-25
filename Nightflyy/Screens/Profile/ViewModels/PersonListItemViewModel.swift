//
//  PersonListItemViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/9/25.
//

import Foundation

@Observable
class PersonListItemViewModel: NSObject {
    
    var account: Account
    
    var isPlusMember: Bool {
        account.hasActiveSubscription
    }
    
    var isPlusProvider: Bool {
        account.isProvider
    }
    
    init(account: Account) {
        self.account = account
        super.init()
    }

    func navigateToProfile() {
        let viewModel = ProfileViewModel(account: account)
        Router.shared.navigateTo(.Profile(viewModel))
    }
    
}
