//
//  AppNotificationsManager.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/1/25.
//

import SwiftUI
import OSLog

@Observable
class AppNotificationsManager {
    
    static let shared = AppNotificationsManager()
    
    var notifications: [AppNotification] = .init()
    
    private init() { }
    
    func fetchNotifications(refetch: Bool = false) async {
        if notifications.isEmpty || refetch {
            do {
                notifications = try await AppNotificationClient.fetchNewAppNotifications()
                notifications.sort { $0.date > $1.date }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteNotification(withId notificationId: String) {
        Task {
            do {
                try await AppNotificationClient.deleteNotification(notificationId)
                notifications.removeAll { $0.id == notificationId }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    
}
