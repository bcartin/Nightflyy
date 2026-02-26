//
//  EventGuestListViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/21/25.
//

import Foundation
import SwiftUI
import Combine

@Observable @MainActor
class EventGuestListViewModel: NSObject {
    
    var event: Event
    var selectedSegment: Int
    let segments = [SegmentedViewOption(id: 1, title: "Going"), SegmentedViewOption(id: 2, title: "Interested")]
    var attending: [String] = []
    var interested: [String] = []
    
    @ObservationIgnored
    @Published var searchText: String = ""
    private var searchCancellable: AnyCancellable?
    
    init(event: Event, selectedSegment: Int) {
        self.event = event
        self.selectedSegment = selectedSegment
        self.attending = event.attending ?? []
        self.interested = event.interested ?? []
        super.init()
        
        searchCancellable = $searchText
            .receive(on: DispatchQueue.main)
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] fragment in
                self?.performSearch(searchText: fragment)
            })
    }
    
    var displayArray: [String] {
        selectedSegment == 1 ? attending : interested
    }
    
    private func performSearch(searchText: String) {
        if searchText.isEmpty {
            self.attending = self.event.attending ?? []
            self.interested = self.event.interested ?? []
        }
        else {
            let algoliaSearchResults = SearchManager.shared.performSearch(searchText: searchText).compactMap(\.objectID)
            let searchAttending = event.attending ?? []
            self.attending = searchAttending.filter {
                algoliaSearchResults.contains($0)
            }
            let searchInterested = event.interested ?? []
            self.interested = searchInterested.filter {
                algoliaSearchResults.contains($0)
            }
        }
    }
    
}
