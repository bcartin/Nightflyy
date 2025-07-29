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
    var event_flyer_url: String?
    var event_id: String?
    var event_name: String?
    var event_status: String?
    var start_reminder: String?
    var created_by: String?
    var profile_image_url: String?
    var username: String?
    var rating: String?
    var topic_id: String?
    var topic_name: String?
}
