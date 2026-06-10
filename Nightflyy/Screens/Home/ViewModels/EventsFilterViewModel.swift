//
//  HomeFilterViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/7/24.
//

import SwiftUI
import CoreLocation

@Observable @MainActor
class EventsFilterViewModel {
    
    var selectedFiler: EventsViewFilter = .nearby
    var cities: [City]
    var filteredCities: [City]
    var searchForVenues: Bool
    
    init(searchForVenues: Bool = false) {
        self.searchForVenues = searchForVenues
        self.cities = Bundle.main.decode("uscities.json")
        self.filteredCities = Bundle.main.decode("uscities.json")
        self.filteredCities.sort { $0.city < $1.city}
    }
    
    func filterCities(filterText: String) {
        if filterText.isEmpty {
            self.filteredCities = cities
        }
        else {
            self.filteredCities = cities.filter({ city in
                let filter = filterText.lowercased()
                let cityName = city.city.lowercased()
                return cityName.contains("\(filter)")
            }).sorted{$0.city < $1.city}
        }
    }
    
    func selectCity(name: String) {
        guard let city = cities.first(where: { $0.city == name }) else {return}
        selectCity(city: city)
    }
    
    func selectCity(city: City) {
        let location = CLLocation(latitude: city.latitude, longitude: city.longitude)
        EventsManager.shared.setLocationEvents(location)
        selectedFiler = .location(city)
        if searchForVenues {
            EventsManager.shared.setLocationVenues(location)
        }
    }
    
    func setFilterAsNearby() {
        Task {
            guard let location = LocationManager.shared.currentLocation else { return }
            selectedFiler = .nearby
            await EventsManager.shared.fetchNearbyVenues(for: location)
        }
    }
    
    func fetchFollowingEvents() {
        Task {
            guard let account =  AccountManager.shared.account else {return}
            await EventsManager.shared.fetchFollowingEvents(account: account)
        }
    }
}
