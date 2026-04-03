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
                event_flyer_url: cached.eventFlyerUrl,
                event_id: cached.eventId,
                event_name: cached.eventName,
                event_status: cached.eventStatus,
                start_reminder: cached.startReminder,
                created_by: cached.createdBy,
                profile_image_url: cached.profileImageUrl,
                username: cached.username,
                rating: cached.rating,
                topic_id: cached.topicId,
                topic_name: cached.topicName
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
        cached.eventFlyerUrl = notificationData.event_flyer_url
        cached.eventId = notificationData.event_id
        cached.eventName = notificationData.event_name
        cached.eventStatus = notificationData.event_status
        cached.startReminder = notificationData.start_reminder
        cached.createdBy = notificationData.created_by
        cached.profileImageUrl = notificationData.profile_image_url
        cached.username = notificationData.username
        cached.rating = notificationData.rating
        cached.topicId = notificationData.topic_id
        cached.topicName = notificationData.topic_name
    }
}
