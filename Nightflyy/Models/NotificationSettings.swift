//
//  NotificationSettings.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/7/24.
//

import Foundation
//import FirebaseFirestoreSwift

struct NotificationSettings: Codable {
    
    var alertReceived: Bool
    var eventComment: Bool
    var eventGoing: Bool
    var followAccepted: Bool
    var followRequest: Bool
    var followStart: Bool
    var inviteToEvent: Bool
    var message: Bool
    
    enum CodingKeys: String, CodingKey {
        case alertReceived = "alert_received"
        case message = "message"
        case eventComment = "event_comment"
        case eventGoing = "event_going"
        case followAccepted = "follow_accepted"
        case followRequest = "follow_request"
        case followStart = "follow_start"
        case inviteToEvent = "invite_to_event"
    }
    
    init(defaultValue: Bool = true) {
        alertReceived = defaultValue
        message = defaultValue
        eventComment = defaultValue
        eventGoing = defaultValue
        followAccepted = defaultValue
        followRequest = defaultValue
        followStart = defaultValue
        inviteToEvent = defaultValue
    }
    
    
}
