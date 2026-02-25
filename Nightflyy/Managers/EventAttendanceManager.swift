//
//  EventAttendanceManager.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/9/25.
//

import Foundation

class EventAttendanceManager {
    
    static let shared = EventAttendanceManager()
    
    private let eventClient: any EventClientProtocol
    private let notificationClient: any AppNotificationClientProtocol
    
    private init(
        eventClient: any EventClientProtocol = EventClient.shared,
        notificationClient: any AppNotificationClientProtocol = AppNotificationClient.shared
    ) {
        self.eventClient = eventClient
        self.notificationClient = notificationClient
    }
    
    func markAsInterested(event: inout Event) async throws {
        guard let uid = AccountManager.shared.account?.uid, let eventId = event.id else { return }
        try await eventClient.addUserToInterested(eventId: eventId, uid: uid)
        if event.interested != nil {
            event.interested?.append(uid)
        }
        else {
            event.interested = [uid]
        }
        try await eventClient.removeUserFromAttending(eventId: eventId, uid: uid)
        removeFromAttending(event: &event)
    }
    
    func markAsAttending(event: inout Event) async throws {
        guard let uid = AccountManager.shared.account?.uid, let eventId = event.id else { return }
        try await eventClient.addUserToAttending(eventId: eventId, uid: uid)
        if event.attending != nil {
            event.attending?.append(uid)
        }
        else {
            event.attending = [uid]
        }
        try await eventClient.removeUserFromInterested(eventId: eventId, uid: uid)
        removeFromInterested(event: &event)
        event.updateCache()
        
        // Send Notification to Event Owner
        if let eventCreator = event.createdBy, !event.isUnclaimed {
            let notification = AppNotification(sender: uid,
                                               date: Date(),
                                               type: AppNotificationType.event_going,
                                               notificationData: NotificationData(event_flyer_url: event.eventFlyerUrl,
                                                                                  event_id: eventId,
                                                                                  event_name: event.eventName,
                                                                                  profile_image_url: AccountManager.shared.account?.profileImageUrl,
                                                                                  username: AccountManager.shared.account?.username))
            try notificationClient.saveNotification(for: eventCreator, notification: notification)
        }
        
        //Schedule Local Notification
        if let startDate = event.startDate {
            let data = ["type":"event", "id":event.uid]
            let date = startDate.addingTimeInterval(-60 * 60)
            LocalNotificationsManager.shared.scheduleLocalNotification(type: .eventReminder(event), date: date, data: data)
        }
        
    }
    
    func markAsNotAttending(event: inout Event) async throws {
        guard let uid = AccountManager.shared.account?.uid, let eventId = event.id else { return }
        try await eventClient.removeUserFromAttending(eventId: eventId, uid: uid)
        try await eventClient.removeUserFromInterested(eventId: eventId, uid: uid)
        removeFromAttending(event: &event)
        removeFromInterested(event: &event)
        event.updateCache()
        LocalNotificationsManager.shared.removeScheduledNotification(type: .eventReminder(event))
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
