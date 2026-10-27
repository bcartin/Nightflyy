//
//  AppNotification.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/1/25.
//

import Foundation
import FirebaseFirestore

struct AppNotification: Identifiable, Codable {

    @DocumentID var id = UUID().uuidString
    var sender: String
    var date: Date
    var type: AppNotificationType
    var notificationData: NotificationData

    var isSelected: Bool = false

    enum CodingKeys: String, CodingKey {
        case id
        case sender
        case date
        case type = "notification_type"
        case notificationData = "notification_data"
    }

}

struct NotificationData: Codable {
    var eventFlyerUrl: String?
    var eventId: String?
    var eventName: String?
    var eventStatus: String?
    var startReminder: String?
    var createdBy: String?
    var profileImageUrl: String?
    var username: String?
    var rating: String?
    var topicId: String?
    var topicName: String?

    /// Firestore field names (snake_case); also read by Cloud Functions.
    enum CodingKeys: String, CodingKey {
        case eventFlyerUrl = "event_flyer_url"
        case eventId = "event_id"
        case eventName = "event_name"
        case eventStatus = "event_status"
        case startReminder = "start_reminder"
        case createdBy = "created_by"
        case profileImageUrl = "profile_image_url"
        case username
        case rating
        case topicId = "topic_id"
        case topicName = "topic_name"
    }
}
