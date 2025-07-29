//
//  VenueSearchViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/28/25.
//

import SwiftUI
import MapKit
import Combine

class VenueSearchViewModel: NSObject, ObservableObject {
    
    
    @Published var searchText: String = ""
    @Published private(set) var venueSearchResults: [Account] = .init()
    
    private var venueSearchCancellable: AnyCancellable?
    
    override init() {
        super.init()
        SearchManager.shared.reloadClient()
        
        venueSearchCancellable = $searchText
            .receive(on: DispatchQueue.main)
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] fragment in
                if !fragment.isEmpty {
                    self?.searchVenues(searchText: fragment)
                }
                else {
                    self?.venueSearchResults = []
                }
            })
    }
    
    private func searchVenues(searchText: String) {
        self.venueSearchResults.removeAll()
        let results = SearchManager.shared.performSearch(searchText: searchText)
        results.forEach { (result) in
            let uid = result.objectID
            if result.type == .venue {
                Task {
                    if let account = await AccountClient.fetchAccount(accountId: uid) {
                        self.venueSearchResults.append(account)
                    }
                }
            }
        }
    }
}
