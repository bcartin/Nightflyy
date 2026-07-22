//
//  LocalNotificationsManager.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 2/12/26.
//

import Foundation
import UserNotifications

class LocalNotificationsManager: LocalNotificationsManaging {
    
    static let shared = LocalNotificationsManager()
    let unCenter = UNUserNotificationCenter.current()
    
    private init() { }
    
    func scheduleLocalNotification(type: LocalNotificationType, date: Date, data: [String: Any]? = nil) {
        
        let content = UNMutableNotificationContent()
        content.title = type.title
        content.sound = .default
        
        if let body =  type.body {
            content.body = body
        }
        
        if let data {
            content.userInfo = data
        }
        
        let dateComponents = Calendar.current.dateComponents(Set(arrayLiteral: Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute), from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: type.identifier, content: content, trigger: trigger)
        unCenter.add(request)
    }
    
    func sendLocalNotification(title: String, body: String?, data: [String: Any]? = nil) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = .default
        
        if let body = body {
            content.body = body
        }
        
        if let data {
            content.userInfo = data
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: "location-notification", content: content, trigger: trigger)
        unCenter.add(request)
    }
    
    func removeAllScheduledNotifications() {
        unCenter.removeAllPendingNotificationRequests()
    }
    
    func removeScheduledNotification(type: LocalNotificationType) {
        unCenter.removePendingNotificationRequests(withIdentifiers: [type.identifier])
    }
    
}
