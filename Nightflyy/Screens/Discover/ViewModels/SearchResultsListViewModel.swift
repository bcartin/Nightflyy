//
//  SearchResultsListViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/7/25.
//

import SwiftUI
import Combine

@Observable
class SearchResultsListViewModel: NSObject {
    
    var selectedSegment: Int = 0
    var segments = [SegmentedViewOption(id: 0, title: "All"),
                    SegmentedViewOption(id: 1, title: "Events"), SegmentedViewOption(id: 2, title: "Venues"), SegmentedViewOption(id: 3, title: "People")]
    
    var searchResults: [SearchResult] = []
    var eventResultsViewModels: [EventListItemViewModel] = .init()
    var venueResultsViewModels: [VenueListItemViewModel] = .init()
    var personResultsViewModels: [PersonListItemViewModel] = .init()
    
    @ObservationIgnored
    @Published var searchText: String = ""
    private var searchCancellable: AnyCancellable?
    
    var algoliaSearchResults: [AlgoliaSearchResult] = []
    
    init(searchResults: [SearchResult]) {
        self.searchResults = searchResults.sorted{$0.id < $1.id}
        super.init()
        self.updateSegmentsTitles()
        self.makeEventResultsViewModels()
        self.makeVenueResultsViewModels()
        self.makePersonResultsViewModels()
    }
    
    override init() {
        SearchManager.shared.reloadClient()
        super.init()
        searchCancellable = $searchText
            .receive(on: DispatchQueue.main)
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] fragment in
                if !fragment.isEmpty {
                    self?.performSearch(searchText: fragment)
                }
                else {
                    self?.searchResults.removeAll()
                }
            })
    }
    
    func updateSegmentsTitles() {
        segments[0].title = "All (\(searchResults.count))"
        segments[1].title = "Events (\(eventsCount))"
        segments[2].title = "Venues (\(venuesCount))"
        segments[3].title = "People (\(peopleCount))"
    }
    
    var eventsCount: Int {
        searchResults.filter { $0.type == .event }.count
    }
    
    var venuesCount: Int {
        searchResults.filter { $0.type == .venue }.count
    }
    
    var peopleCount: Int {
        searchResults.filter { $0.type == .person }.count
    }
    
    private func makeEventResultsViewModels() {
        eventResultsViewModels = searchResults.filter{ $0.type == .event }.map{ EventListItemViewModel(event: $0.event!) }.sortedByDate()
    }
    
    private func makeVenueResultsViewModels() {
        venueResultsViewModels = searchResults.filter{ $0.type == .venue }.map{ VenueListItemViewModel(venue: $0.account!) }
    }
    
    private func makePersonResultsViewModels() {
        personResultsViewModels = searchResults.filter{ $0.type == .person }.map{ PersonListItemViewModel(account: $0.account!) }
    }
    
    private func performSearch(searchText: String) {
        self.algoliaSearchResults = SearchManager.shared.performSearch(searchText: searchText)
        self.makeViewModels()
    }
    
    func getSearchResults() async -> [SearchResult] {
        var searchResults: [SearchResult] = .init()
        await withTaskGroup(of: SearchResult?.self) { group in
            for result in self.algoliaSearchResults {
                group.addTask {
                    return await self.fetchResult(result)
                }
            }
            for await result in group {
                if let result = result {
                    searchResults.append(result)
                }
            }
        }
        return searchResults.sorted{$0.id < $1.id}
    }
    
    private func fetchResult(_ algoliaResult: AlgoliaSearchResult) async -> SearchResult? {
        switch algoliaResult.type {
        
        case .event:
            if let event = await EventClient.fetchEvent(eventId: algoliaResult.objectID), event.isFutureEvent, !(event.eventIsPrivate ?? false) {
                return SearchResult(type: .event, account: nil, event: event, id: algoliaResult.objectID)
            } else {
                return nil
            }
        case .person, .venue:
            if let account = await AccountClient.fetchAccount(accountId: algoliaResult.objectID) {
                return SearchResult(type: algoliaResult.type, account: account, event: nil, id: algoliaResult.objectID)
            } else {
                return nil
            }
        }
    }
    
    private func makeViewModels() {
        Task {
            self.searchResults = await getSearchResults()
            self.updateSegmentsTitles()
            self.makeEventResultsViewModels()
            self.makeVenueResultsViewModels()
            self.makePersonResultsViewModels()
        }
    }
    
    func clearSearchResults() {
        searchText = ""
        searchResults.removeAll()
        eventResultsViewModels.removeAll()
        venueResultsViewModels.removeAll()
        personResultsViewModels.removeAll()
        self.updateSegmentsTitles()
    }
    
}
