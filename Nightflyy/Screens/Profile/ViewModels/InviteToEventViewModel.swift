//
//  InviteToEventViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/17/25.
//

import Foundation
import SwiftUI

@Observable
class InviteToEventViewModel: NSObject {
    
    var attendingEvents: [EventListItemViewModel] = .init()
    var futureHostingEvents: [EventListItemViewModel] = .init()
    var accountToInvite: Account
    var selectedEvents: [String] = .init()
    
    init(accountToInvite: Account) {
        self.accountToInvite = accountToInvite
    }

    func loadEvents() async {
        await EventsManager.shared.fetchHostingEvents()
        await EventsManager.shared.fetchAttendingEvents()
        
        attendingEvents = EventsManager.shared.attendingEvents.map{EventListItemViewModel(event: $0)}.sortedByDate()
        futureHostingEvents = EventsManager.shared.hostingEvents.removingPastEvents().map{EventListItemViewModel(event: $0)}.sortedByDate()
    }
    
    func selectOrDeselectEvent(_ eventId: String) {
        if let index = selectedEvents.firstIndex(of: eventId) {
            selectedEvents.remove(at: index)
        } else {
            selectedEvents.append(eventId)
        }
    }
    
    func sendInvites() {
        guard let uid = AccountManager.shared.account?.uid else { return }
        selectedEvents.forEach { eventId in
            
            var event: Event? = nil          
            event = attendingEvents.first{ $0.event.uid == eventId}?.event
            if event == nil {
                event = futureHostingEvents.first{ $0.event.uid == eventId}?.event
            }
            
            if let event = event {
                let notification = AppNotification(sender: uid,
                                                   date: Date(),
                                                   type: AppNotificationType.invite_to_event,
                                                   notificationData: NotificationData(event_flyer_url: event.eventFlyerUrl,
                                                                                      event_id: event.uid,
                                                                                      event_name: event.eventName,
                                                                                      profile_image_url: AccountManager.shared.account?.profileImageUrl,
                                                                                      username: AccountManager.shared.account?.username))
                try? AppNotificationClient.saveNotification(for: accountToInvite.uid, notification: notification)
            }
        }
        General.showSuccessMessage(message: "Invites sent!", imageName: "checkmark")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            Router.shared.navigateBack()
        }
        
    }
}
