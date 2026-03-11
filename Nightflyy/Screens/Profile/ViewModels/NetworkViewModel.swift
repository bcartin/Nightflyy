//
//  NetworkViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/15/24.
//

import Foundation
import SwiftUI
import Combine

@Observable @MainActor
class NetworkViewModel: Hashable {
    
    nonisolated let id: String
    
    nonisolated static func == (lhs: NetworkViewModel, rhs: NetworkViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var account: Account
    var displayFollowers: [String] = []
    var displayFollowing: [String] = []
    var selectedSegment: Int
    let segments = [SegmentedViewOption(id: 1, title: "Followers"), SegmentedViewOption(id: 2, title: "Following")]
    
    @ObservationIgnored
    @Published var searchText: String = ""
    private var searchCancellable: AnyCancellable?
    
    init(account: Account, selectedSegment: Int) {
        self.id = account.uid
        self.account = account
        self.displayFollowers = account.followers ?? []
        self.displayFollowing = account.following ?? []
        self.selectedSegment = selectedSegment
        
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
