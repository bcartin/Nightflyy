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
    var recipient: String
    var date: Date?
    var type: MessageType
    var messageData: MessageData
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case type = "message_type"
        case sender
        case recipient
        case messageData = "message_data"
    }
    
}

struct MessageData: Codable {
    var message: String?
    var event_name: String?
    var event_id: String?
    var event_flyer_url: String?
    var username: String?
    var uid: String?
    var profile_image_url: String?
}
