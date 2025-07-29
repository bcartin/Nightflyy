//
//  InviteFromEventViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/11/25.
//

import Foundation
import SwiftUI

@Observable
class InviteFromEventViewModel: NSObject {
    
    var event: Event
    var followers = AccountManager.shared.account?.followers ?? []
    var error: Error?
    
    init(event: Event) {
        self.event = event
    }
    
    func isInvited(accountId: String) -> Bool {
        return event.invited?.contains(accountId) ?? false
    }
    
    func style(for accountId: String) -> ActionButtonStyle {
        return isInvited(accountId: accountId) ? .actionSecondary : .actionPrimary
    }
    
    func label(for accountId: String) -> String {
        return isInvited(accountId: accountId) ? "Invited" : "Invite"
    }
    
    func isDisabled(for accountId: String) -> Bool {
        return isInvited(accountId: accountId)
    }
    
    func inviteToEvent(accountId: String) {
        Task {
            do {
                try await EventClient.addUserToInvited(eventId: event.uid, uid: accountId)
                event.invited?.append(accountId)
                
                guard let uid = AccountManager.shared.account?.uid else { return }
                let notification = AppNotification(sender: uid,
                                                   date: Date(),
                                                   type: AppNotificationType.invite_to_event,
                                                   notificationData: NotificationData(event_flyer_url: event.eventFlyerUrl,
                                                                                      event_id: event.uid,
                                                                                      event_name: event.eventName,
                                                                                      profile_image_url: AccountManager.shared.account?.profileImageUrl,
                                                                                      username: AccountManager.shared.account?.username))
                try AppNotificationClient.saveNotification(for: accountId, notification: notification)
            }
            catch {
                self.error = error
            }
        }
    }
}
