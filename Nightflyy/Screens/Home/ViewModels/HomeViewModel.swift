//
//  HomeViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/26/24.
//

import UIKit
import CoreLocation

@Observable
class HomeViewModel {
    
    var isShowingNFPView: Bool {
        get {
            NFPManager.shared.showNFPView
        }
        set {
            NFPManager.shared.showNFPView = newValue
        }
    }
    
    var filterViewModel = EventsFilterViewModel()
    
    var selectedFiler: EventsViewFilter {
        get { filterViewModel.selectedFiler }
        set { scrollPosition = 0 }
    }
    var scrollPosition: Int? = 0
    
    var displayEvents: [Event] {
        switch filterViewModel.selectedFiler {
            
        case .nearby:
            EventsManager.shared.nearbyEvents
        case .following:
            EventsManager.shared.followingEvents
        case .location(_):
            EventsManager.shared.locationEvents
        }
    }
    
    var headerText: String {
        switch filterViewModel.selectedFiler {
        case .nearby:
            return "Nearby"
        case .following:
            return "Following"
        case .location(let city):
            return "\(city.city), \(city.state)"
        }
    }
    
    var isPlusMember: Bool {
        AccountManager.shared.isPlusMember
    }
    
    func openSettings() {
        if LocationManager.shared.permissionChosen {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        else {
            LocationManager.shared.askPermission()
        }
    }
    
    func navigateToCreateNewEvent() {
        let viewModel = CreateEventViewModel(event: Event())
        Router.shared.navigateTo(.CreateEvent(viewModel))
    }
    
    func showNFPView() {
        NFPManager.shared.showNFPView = true
    }
}
