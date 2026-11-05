//
//  Message.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/25/24.
//

import Foundation
import FirebaseFirestore

struct Message: Codable, Identifiable {

    @DocumentID var id = UUID().uuidString
    var sender: String
    var senderName: String
    var recipient: String
    var date: Date?
    var type: MessageType
    var messageData: MessageData

    enum CodingKeys: String, CodingKey {
        case id
        case date
        case type = "message_type"
        case sender
        case senderName = "sender_name"
        case recipient
        case messageData = "message_data"
    }

}

struct MessageData: Codable {
    var message: String?
    var eventName: String?
    var eventId: String?
    var eventFlyerUrl: String?
    var username: String?
    var uid: String?
    var profileImageUrl: String?

    /// Firestore field names (snake_case).
    enum CodingKeys: String, CodingKey {
        case message
        case eventName = "event_name"
        case eventId = "event_id"
        case eventFlyerUrl = "event_flyer_url"
        case username
        case uid
        case profileImageUrl = "profile_image_url"
    }
}
