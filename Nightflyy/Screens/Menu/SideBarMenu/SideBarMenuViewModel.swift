//
//  SideBarMenuViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/7/24.
//

import Foundation

@Observable @MainActor
class SideBarMenuViewModel {
    
    var presentSheet: Bool = false
    var selectedMenuItem: MenuItem = .accountInfo(type: .personal)
    
    var isPlusMember: Bool {
        return NFPManager.shared.isPlusMember
    }
    
    var bannerText: String {
        isPlusMember ? "Nightflyy+ Member" : "Upgrade to Nightflyy+"
    }
    
    func navigateToProfile() {
        let account = AccountManager.shared.account
        Router.shared.navigateToProfile(account: account)
    }
    
    func selectMenuItem(_ item: MenuItem) {
        selectedMenuItem = item
        presentSheet.toggle()
    }
    
}
