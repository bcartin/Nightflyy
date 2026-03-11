//
//  LocalNotificationsManaging.swift
//  Nightflyy
//

import Foundation

protocol LocalNotificationsManaging {
    func scheduleLocalNotification(type: LocalNotificationType, date: Date, data: [String: Any]?)
    func removeScheduledNotification(type: LocalNotificationType)
    func removeAllScheduledNotifications()
}
