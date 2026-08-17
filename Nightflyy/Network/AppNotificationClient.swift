//
//  AppNotificationClient.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/1/25.
//

import Foundation
import FirebaseFirestore
import OSLog

class AppNotificationClient {
    
    static let shared = AppNotificationClient()
    
    static func fetchNewAppNotifications(lastUpdated: Date? = nil) async throws -> [AppNotification] {
        guard let uid = AccountManager.shared.account?.uid else {
            throw NetworkError.unauthorized
        }
        var notifications: [AppNotification] = .init()
        var dbRef: Query = FirebaseManager.shared.db.collection(FirestoreCollections.Accounts.value).document(uid).collection(FirestoreCollections.Accounts.notifications)
        if let lastUpdated {
            dbRef = dbRef.whereField("date", isGreaterThan: lastUpdated)
        }
        let snapshot = try await dbRef.getDocuments()
        notifications = try snapshot.documents.map({ document in
            return try document.data(as: AppNotification.self)
        })
        return notifications
    }
    
    static func deleteNotification(_ notificationId: String) async throws {
        guard let uid = AccountManager.shared.account?.uid else {
            return
        }
        let dbRef = FirebaseManager.shared.db.collection(FirestoreCollections.Accounts.value).document(uid).collection(FirestoreCollections.Accounts.notifications).document(notificationId)
        try await dbRef.delete()
    }
    
    static func saveNotification(for accountId: String, notification: AppNotification) throws {
        let db = FirebaseManager.shared.db
        try db.collection(FirestoreCollections.Accounts.value).document(accountId).collection(FirestoreCollections.Notifications.value).addDocument(from: notification)
    }
}

// MARK: - AppNotificationClientProtocol

extension AppNotificationClient: AppNotificationClientProtocol {
    func fetchNewAppNotifications(lastUpdated: Date?) async throws -> [AppNotification] {
        try await Self.fetchNewAppNotifications(lastUpdated: lastUpdated)
    }
    
    func deleteNotification(_ notificationId: String) async throws {
        try await Self.deleteNotification(notificationId)
    }
    
    func saveNotification(for accountId: String, notification: AppNotification) throws {
        try Self.saveNotification(for: accountId, notification: notification)
    }
}

