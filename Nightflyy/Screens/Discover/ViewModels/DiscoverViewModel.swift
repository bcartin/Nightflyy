//
//  SearchViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/7/24.
//

import SwiftUI
//import Combine

@Observable
class DiscoverViewModel {
    
    var selectedVenues: [String] = .init()
    var selectedMusic: [String] = .init()
    var selectedCrowds: [String] = .init()
    var selectedDate: Date?
    var selectedMaxCover: Int?
    var selectedRating: Int?
    var presentFilterView: Bool = false
    var selectedFilterView: FilterView?
        
    var filterViewModel = EventsFilterViewModel(searchForVenues: true)
    
    var searchText: String = ""
    var searchResultsViewModel: SearchResultsListViewModel!
    
    init() {
        searchResultsViewModel = SearchResultsListViewModel()
    }
    
    func clearFilters() {
        selectedVenues.removeAll()
        selectedMusic.removeAll()
        selectedCrowds.removeAll()
        selectedDate = nil
        selectedRating = nil
        selectedMaxCover = nil
        searchText = ""
    }
    
    var locationFilterButtonText: String {
        switch filterViewModel.selectedFiler {
        case .nearby:
            return "Nearby"
        case .following:
            return "Following"
        case .location(let city):
            return "\(city.city), \(city.state)"
        }
    }
    
    var dateFilterButtonText: String {
        return hasDateFilter ? selectedDate?.stringValue(format: "MMM, dd") ?? "" : "Date"
    }
    
    var hasDateFilter: Bool {
        selectedDate != nil
    }
    
    var coverFilterButtonText: String {
        return hasCoverFilter ? "$\(selectedMaxCover ?? 0)" : "Cover"
    }
    
    var hasCoverFilter: Bool {
        selectedMaxCover != nil
    }
    
    var ratingFilterButtonText: String {
        return hasRatingFilter ? "\(selectedRating ?? 0)⭐️" : "Rating"
    }
    
    var hasRatingFilter: Bool {
        selectedRating != nil
    }
    
    var displayEvents: [Event] {
        switch filterViewModel.selectedFiler {
            
        case .nearby:
            filterEvents(EventsManager.shared.nearbyEvents)
        case .following:
            filterEvents(EventsManager.shared.followingEvents)
        case .location(_):
            filterEvents(EventsManager.shared.locationEvents)
        }
    }
    
    var resultsCount: Int {
        return filteredDisplayEvents.count + filteredVenues.count
    }
    
    var filteredDisplayEvents: [Event] {
        displayEvents
            .filter {
                selectedVenues.contains($0.eventVenueType ?? "") || selectedVenues.isEmpty
            }
            .filter {
                guard let eventMusic = $0.eventMusic else { return selectedMusic.isEmpty }
                return selectedMusic.contains(where: eventMusic.contains) || selectedMusic.isEmpty
            }
            .filter {
                guard let eventCrowds = $0.eventCrowds else { return selectedCrowds.isEmpty }
                return selectedCrowds.contains(where: eventCrowds.contains) || selectedCrowds.isEmpty
            }
    }
    
    var filteredVenues: [Account] {
        filterViewModel.venues
            .filter {
                selectedVenues.contains($0.venueType ?? "") || selectedVenues.isEmpty
            }
            .filter {
                guard let venueMusic = $0.music else { return selectedMusic.isEmpty }
                return selectedMusic.contains(where: venueMusic.contains) || selectedMusic.isEmpty
            }
            .filter {
                guard let venueCrowds = $0.clientele else { return selectedCrowds.isEmpty }
                return selectedCrowds.contains(where: venueCrowds.contains) || selectedCrowds.isEmpty
            }
    }
    
    var hasResults: Bool {
        resultsCount > 0
    }
    
    func makeFilterResultsViewModel() -> SearchResultsListViewModel {
        var searchResults: [SearchResult] = .init()
        searchResults.append(contentsOf: filteredDisplayEvents.map {
            return SearchResult(type: .event, account: nil, event: $0, id: $0.uid)
        })
        searchResults.append(contentsOf: filteredVenues.map {
            return SearchResult(type: .venue, account: $0, event: nil, id: $0.uid)
        })
        return SearchResultsListViewModel(searchResults: searchResults)
    }
    
    func navigateToResultsView() {
        let viewModel = makeFilterResultsViewModel()
        Router.shared.navigateTo(.SearchResultsListView(viewModel))
    }
    
    func selectFilterView(_ filter: FilterView) {
        selectedFilterView = filter
        presentFilterView = true
    }
    
    func filterEvents(_ events: [Event]) -> [Event] {
        var events = events
        
        //Filter By Music
        events = selectedMusic.isEmpty ? events : events.filter{$0.eventMusic!.contains(where: selectedMusic.contains)}
        
        //Filter By Venue Type
        events = selectedVenues.isEmpty ? events : events.filter{ selectedVenues.contains($0.eventVenueType ?? "")}
        
        //Filter By Crowds
        events = selectedCrowds.isEmpty ? events : events.filter{$0.eventCrowds!.contains(where: selectedCrowds.contains)}
        
        //Filter By Date
        if let selectedDate = selectedDate {
            events = events.filter{$0.startDate!.isSameDay(as: selectedDate)}
        }

        //Filter By Cover
        if let selectedMaxCover = selectedMaxCover {
            events = events.filter{$0.maxPrice ?? 0 <= selectedMaxCover}
        }
        
        return events
    }
}

extension DiscoverViewModel {
    
    enum FilterView {
        case date
        case cover
        case rating
    }
    
}
