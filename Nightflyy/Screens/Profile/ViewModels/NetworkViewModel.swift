//
//  NetworkViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/15/24.
//

import Foundation
import SwiftUI

@Observable
class NetworkViewModel: NSObject {
    
    var account: Account
    var searchText: String = ""
    var selectedSegment: Int
    let segments = [SegmentedViewOption(id: 1, title: "Followers"), SegmentedViewOption(id: 2, title: "Following")]
    
    init(account: Account, selectedSegment: Int) {
        self.account = account
        self.selectedSegment = selectedSegment
    }
    
    var displayArray: [String] {
        selectedSegment == 1 ? account.followers ?? [] : account.following ?? []
    }
    
    var filteredFollowers: [String] {
        if searchText.isEmpty {
            return account.followers ?? []
        }
        else {
            return account.followers?.filter {$0.contains(searchText)} ?? []
        }
    }
}
