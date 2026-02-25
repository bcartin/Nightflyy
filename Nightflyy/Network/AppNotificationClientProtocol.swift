//
//  AppNotificationClientProtocol.swift
//  Nightflyy
//

import Foundation

protocol AppNotificationClientProtocol {
    func fetchNewAppNotifications(lastUpdated: Date?) async throws -> [AppNotification]
    func deleteNotification(_ notificationId: String) async throws
    func saveNotification(for accountId: String, notification: AppNotification) throws
}
