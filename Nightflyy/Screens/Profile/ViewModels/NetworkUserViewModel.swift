//
//  NetworkUserViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/15/24.
//

import Foundation
import SwiftUI

@Observable
class NetworkUserViewModel: NSObject {
    
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
        guard let account = account else { return }
        let viewModel = ProfileViewModel(account: account)
        Router.shared.navigateTo(.Profile(viewModel))
    }
    
//    var buttonLabel: String {
//        let followers = AccountManager.shared.account?.followers ?? []
//        let following = AccountManager.shared.account?.following ?? []
//        if followers.contains(account?.uid ?? "") && selectedSegment == 1 {
//            return "Remove"
//        }
//        else if following.contains(account?.uid ?? "") {
//            return "Unfollow"
//        }
//        else {
//            return "Follow"
//        }
//    }
    
//    var buttonBackgroundColor: Color {
//        let followers = AccountManager.shared.account?.followers ?? []
//        let following = AccountManager.shared.account?.following ?? []
//        if followers.contains(account?.uid ?? "") && selectedSegment == 1 {
//            return Color.mainPurple
//        }
//        else if following.contains(account?.uid ?? "") {
//            return Color.clear
//        }
//        else {
//            return Color.mainPurple
//        }
//    }
//    
//    var buttonBorderColor: Color {
//        let followers = AccountManager.shared.account?.followers ?? []
//        let following = AccountManager.shared.account?.following ?? []
//        if followers.contains(account?.uid ?? "") && selectedSegment == 1 {
//            return Color.clear
//        }
//        else if following.contains(account?.uid ?? "") {
//            return Color.white
//        }
//        else {
//            return Color.clear
//        }
//    }
    
}
