//
//  EventCardSmallViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 7/17/25.
//

import Foundation

@Observable
class EventCardSmallViewModel {
    
    var event: Event
    var eventOwner: Account?
    
    init(event: Event) {
        self.event = event
        fetchEventOwner()
    }
    
    private func fetchEventOwner() {
        if let ownerId = event.createdBy, ownerId != "unclaimed" {
            Task {
                eventOwner = await AccountClient.fetchAccount(accountId: ownerId)
            }
        }
    }
    
    func navigateToEvent() {
        let viewModel = EventViewModel(event: event, eventOwner: eventOwner)
        Router.shared.navigateTo(.Event(viewModel))
    }
}
