//
//  AppNotificationType.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/1/25.
//

enum AppNotificationType: String, Codable {
    case follow_request = "follow_request"
    case follow_accepted = "follow_accepted"
    case follow_start = "follow_start"
    case event_assigned = "event_assigned"
    case invite_to_event = "invite_to_event"
    case event_going = "event_going"
    case event_comment = "event_comment"
    case review_submitted = "review_submitted"
    case event_created = "event_created"
    case event_alert = "event_alert"
    case event_interested = "event_interested"
    
    var mainLabelText: String {
        switch self {
        case .follow_request:
            return "requested to follow you."
        case .follow_accepted:
            return "accepted your follow request."
        case .follow_start:
            return "started following you."
        case .event_assigned:
            return "You've been invited to claim an event."
        case .invite_to_event:
            return "invited you to an event."
        case .event_going:
            return "is coming to your event."
        case .event_comment:
            return "commented on your event."
        case .review_submitted:
            return "rated your venue."
        case .event_created:
            return "has posted a new event."
        case .event_alert:
            return "Remember to update the event status."
        case .event_interested:
            return " is interested in "
        }
    }
}
