//
//  NetworkUserViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/15/24.
//

import Foundation
import SwiftUI

@Observable @MainActor
class NetworkUserViewModel {
    
    var account: Account?
    var selectedSegment: Int
    
    init(selectedSegment: Int) {
        self.selectedSegment = selectedSegment
    }
    
    init(account: Account) {
        self.selectedSegment = 0
        self.account = account
    }
    
    func fetchAccount(uid: String) async {
        self.account = await AccountClient.fetchAccount(accountId: uid)
    }
    
    func goToProfile() {
        Router.shared.navigateToProfile(account: account)
    }

    
}
