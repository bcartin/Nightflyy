//
//  EventAttendanceManager.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/9/25.
//

import Foundation

class EventAttendanceManager {
    
    static let shared = EventAttendanceManager()
    
    private init() {}
    
    func markAsInterested(event: inout Event) async throws {
        guard let uid = AccountManager.shared.account?.uid, let eventId = event.id else { return }
        try await EventClient.addUserToInterested(eventId: eventId, uid: uid)
        if event.interested != nil {
            event.interested?.append(uid)
        }
        else {
            event.interested = [uid]
        }
        try await EventClient.removeUserFromAttending(eventId: eventId, uid: uid)
        removeFromAttending(event: &event)
    }
    
    func markAsAttenging(event: inout Event) async throws {
        guard let uid = AccountManager.shared.account?.uid, let eventId = event.id else { return }
        try await EventClient.addUserToAttending(eventId: eventId, uid: uid)
        if event.attending != nil {
            event.attending?.append(uid)
        }
        else {
            event.attending = [uid]
        }
        try await EventClient.removeUserFromInterested(eventId: eventId, uid: uid)
        removeFromInterested(event: &event)
        event.updateCache()
        
        guard let eventCreator = event.createdBy else { return }
        let notification = AppNotification(sender: uid,
                                              date: Date(),
                                              type: AppNotificationType.event_going,
                                              notificationData: NotificationData(event_flyer_url: event.eventFlyerUrl,
                                                                                 event_id: eventId,
                                                                                 event_name: event.eventName,
                                                                                 profile_image_url: AccountManager.shared.account?.profileImageUrl,
                                                                                 username: AccountManager.shared.account?.username))
        try AppNotificationClient.saveNotification(for: eventCreator, notification: notification)
    }
    
    func markAsNotAttending(event: inout Event) async throws {
        guard let uid = AccountManager.shared.account?.uid, let eventId = event.id else { return }
        try await EventClient.removeUserFromAttending(eventId: eventId, uid: uid)
        try await EventClient.removeUserFromInterested(eventId: eventId, uid: uid)
        removeFromAttending(event: &event)
        removeFromInterested(event: &event)
        event.updateCache()
    }
    
    private func removeFromAttending(event: inout Event) {
        guard let uid = AccountManager.shared.account?.uid else { return }
        if let index = event.attending?.firstIndex(of: uid) {
            event.attending?.remove(at: index)
            event.updateCache()
        }
    }
    
    private func removeFromInterested(event: inout Event) {
        guard let uid = AccountManager.shared.account?.uid else { return }
        if let index = event.interested?.firstIndex(of: uid) {
            event.interested?.remove(at: index)
            event.updateCache()
        }
    }
    
}
