//
//  AppNotification+CoreData.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/3/26.
//

import CoreData

extension AppNotification {

    /// Creates an `AppNotification` from a `CachedAppNotification` Core Data entity.
    static func from(_ cached: CachedAppNotification) -> AppNotification? {
        guard let id = cached.id,
              let sender = cached.sender,
              let date = cached.date,
              let typeRaw = cached.notificationType,
              let type = AppNotificationType(rawValue: typeRaw) else {
            return nil
        }
        var notification = AppNotification(
            sender: sender,
            date: date,
            type: type,
            notificationData: NotificationData(
                eventFlyerUrl: cached.eventFlyerUrl,
                eventId: cached.eventId,
                eventName: cached.eventName,
                eventStatus: cached.eventStatus,
                startReminder: cached.startReminder,
                createdBy: cached.createdBy,
                profileImageUrl: cached.profileImageUrl,
                username: cached.username,
                rating: cached.rating,
                topicId: cached.topicId,
                topicName: cached.topicName
            )
        )
        notification.id = id
        return notification
    }

    /// Populates a `CachedAppNotification` entity with values from this struct.
    func populate(_ cached: CachedAppNotification) {
        cached.id = id
        cached.sender = sender
        cached.date = date
        cached.notificationType = type.rawValue
        cached.eventFlyerUrl = notificationData.eventFlyerUrl
        cached.eventId = notificationData.eventId
        cached.eventName = notificationData.eventName
        cached.eventStatus = notificationData.eventStatus
        cached.startReminder = notificationData.startReminder
        cached.createdBy = notificationData.createdBy
        cached.profileImageUrl = notificationData.profileImageUrl
        cached.username = notificationData.username
        cached.rating = notificationData.rating
        cached.topicId = notificationData.topicId
        cached.topicName = notificationData.topicName
    }
}
