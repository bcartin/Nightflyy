//
//  UpcomingViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 2/28/25.
//

import SwiftUI

@Observable
class UpcomingViewModel: NSObject {

    var eventsAttending: [EventListItemViewModel] = []
    var eventsInvited: [EventListItemViewModel] = []
    var eventsInterested: [EventListItemViewModel] = []
    
    func setupViewModels() {
        eventsAttending = EventsManager.shared.attendingEvents.map{EventListItemViewModel(event: $0, autoFetchOwner: true)}.sortedByDate()
        eventsInvited = EventsManager.shared.invitedEvents.map{EventListItemViewModel(event: $0, autoFetchOwner: true)}.sortedByDate()
        eventsInterested = EventsManager.shared.interestedEvents.map{EventListItemViewModel(event: $0, autoFetchOwner: true)}.sortedByDate()
    }
    
    func fetchEvents(refetch: Bool = false) async {
        await EventsManager.shared.fetchHubEvents(refetch: refetch)
        setupViewModels()
    }
    

    
}
