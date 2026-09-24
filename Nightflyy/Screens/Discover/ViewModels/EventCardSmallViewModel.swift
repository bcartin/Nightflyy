//
//  EventCardSmallViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 7/17/25.
//

import Foundation

@Observable @MainActor
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
        Router.shared.navigateToEvent(event: event, eventOwner: eventOwner)
    }
}
