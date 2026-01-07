//
//  NetworkViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/15/24.
//

import Foundation
import SwiftUI
import Combine

@Observable
class NetworkViewModel: NSObject {
    
    var account: Account
    var displayFollowers: [String] = []
    var displayFollowing: [String] = []
    var selectedSegment: Int
    let segments = [SegmentedViewOption(id: 1, title: "Followers"), SegmentedViewOption(id: 2, title: "Following")]
    
    @ObservationIgnored
    @Published var searchText: String = ""
    private var searchCancellable: AnyCancellable?
    
    init(account: Account, selectedSegment: Int) {
        self.account = account
        self.displayFollowers = account.followers ?? []
        self.displayFollowing = account.following ?? []
        self.selectedSegment = selectedSegment
        super.init()
        
        searchCancellable = $searchText
            .receive(on: DispatchQueue.main)
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] fragment in
                self?.performSearch(searchText: fragment)
            })
    }
    
    private func performSearch(searchText: String) {
        if searchText.isEmpty {
            self.displayFollowers = self.account.followers ?? []
            self.displayFollowing = self.account.following ?? []
        }
        else {
            let algoliaSearchResults = SearchManager.shared.performSearch(searchText: searchText).compactMap(\.objectID)
            let followers = account.followers ?? []
            self.displayFollowers = followers.filter {
                algoliaSearchResults.contains($0)
            }
            let following = account.following ?? []
            self.displayFollowing = following.filter {
                algoliaSearchResults.contains($0)
            }
        }
    }
}
