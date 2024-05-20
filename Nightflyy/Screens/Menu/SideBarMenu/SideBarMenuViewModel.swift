//
//  SideBarMenuViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/7/24.
//

import Foundation

@Observable
class SideBarMenuViewModel {
    
    var presentSheet: Bool = false
    var selectedMenuItem: MenuItem = .accountInfo
    
    func navigateToProfile() {
        if let account = AccountManager.shared.account {
            let viewModel = ProfileViewModel(account: account)
            Router.shared.navigateTo(.Profile(viewModel))
        }
    }
    
    func selectMenuItem(_ item: MenuItem) {
        selectedMenuItem = item
        presentSheet.toggle()
    }
    
}
