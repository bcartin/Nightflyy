//
//  LocalNotificationType.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 2/12/26.
//

enum LocalNotificationType {
    
    case perkReminder
    case eventReminder(Event)
    
    var identifier: String {
        switch self {
            
        case .perkReminder:
            "perk_reminder_notification"
        case .eventReminder(let event):
            "event_reminder_notification_\(event.uid)"
        }
    }
    
    var title: String {
        switch self {
            
        case .perkReminder:
            "Remember to use your Plus Perk ✅"
        case .eventReminder(_):
            "Your Vibe Starts Soon ✨"
        }
    }
    
    var body: String? {
        switch self {
        case .perkReminder:
            nil
        case .eventReminder(let event):
            "\(event.eventName ?? "Event") begins in 1 hour. Tap for details."}
    }
}
