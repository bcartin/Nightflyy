//
//  AppNotificationClient.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/1/25.
//

import Foundation
import FirebaseFirestore
//import FirebaseFirestoreSwift
import OSLog

class AppNotificationClient {
    
    
    static func fetchNewAppNotifications(lastUpdated: Date? = nil) async throws -> [AppNotification] {
        guard let uid = AccountManager.shared.account?.uid else {
            return []
        }
        var notifications: [AppNotification] = .init()
        let dbRef = FirebaseManager.shared.db.collection(FirestoreCollections.Accounts.value).document(uid).collection(FirestoreCollections.Accounts.notifications)
//            .whereField("date", isGreaterThan: lastUpdated ?? Date(timeIntervalSince1970: 0))
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

