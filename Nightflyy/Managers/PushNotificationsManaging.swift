//
//  PushNotificationsManaging.swift
//  Nightflyy
//

import Foundation

protocol PushNotificationsManaging {
    func subscribeToNotifications(target: PushNotificationTarget)
    func unsubscribeFromNotifications(target: PushNotificationTarget)
}
