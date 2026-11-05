//
//  AppNotificationType.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/1/25.
//

enum AppNotificationType: String, Codable {
    case followRequest = "follow_request"
    case followAccepted = "follow_accepted"
    case followStart = "follow_start"
    case eventAssigned = "event_assigned"
    case inviteToEvent = "invite_to_event"
    case eventGoing = "event_going"
    case eventComment = "event_comment"
    case reviewSubmitted = "review_submitted"
    case eventCreated = "event_created"
    case eventAlert = "event_alert"
    case eventInterested = "event_interested"

    var mainLabelText: String {
        switch self {
        case .followRequest:
            return "requested to follow you."
        case .followAccepted:
            return "accepted your follow request."
        case .followStart:
            return "started following you."
        case .eventAssigned:
            return "You've been invited to claim an event."
        case .inviteToEvent:
            return "invited you to an event."
        case .eventGoing:
            return "is coming to your event."
        case .eventComment:
            return "commented on your event."
        case .reviewSubmitted:
            return "rated your venue."
        case .eventCreated:
            return "has posted a new event."
        case .eventAlert:
            return "Remember to update the event status."
        case .eventInterested:
            return " is interested in "
        }
    }
}
