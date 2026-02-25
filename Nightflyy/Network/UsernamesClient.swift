//
//  UsernamesClient.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/10/25.
//

import Foundation
import FirebaseFirestore
import OSLog

class UsernamesClient {
    
    static let shared = UsernamesClient()
    
    static func isUsernameAvailable(_ username: String) async -> Bool {
        do {
            let reference = FirebaseManager.shared.db.collection(FirestoreCollections.Usernames.value)
                .whereField(FirestoreCollections.Usernames.usernames, arrayContains: username)
            let snapshot = try await reference.getDocuments()
            return snapshot.isEmpty
        }
        catch {
            Logger.network.error("Error checking username availability: \(error.localizedDescription)")
            return false
        }
    }
    
    static func saveUsername(username: String) async {
        let document = String(describing: username.first ?? "a")
        do {
            try await FirebaseManager.shared.db.collection(FirestoreCollections.Usernames.value)
                .document(document)
                .updateData([
                    FirestoreCollections.Usernames.usernames: FieldValue.arrayUnion([username])])
        }
        catch {
            Logger.network.error("Error saving username: \(error.localizedDescription)")
            try? await FirebaseManager.shared.db.collection(FirestoreCollections.Usernames.value)
                .document(document).setData([FirestoreCollections.Usernames.usernames: [username]])
        }
    }
    
    static func deleteUsername(username: String) async {
        let document = String(describing: username.first ?? "a")
        do {
            try await FirebaseManager.shared.db.collection(FirestoreCollections.Usernames.value)
                .document(document)
                .updateData([
                    FirestoreCollections.Usernames.usernames: FieldValue.arrayRemove([username])])
        }
        catch {
            Logger.network.error("Error deleting username: \(error.localizedDescription)")
        }
    }
    
}
// MARK: - UsernamesClientProtocol

extension UsernamesClient: UsernamesClientProtocol {
    func isUsernameAvailable(_ username: String) async -> Bool {
        await Self.isUsernameAvailable(username)
    }
    
    func saveUsername(username: String) async {
        await Self.saveUsername(username: username)
    }
    
    func deleteUsername(username: String) async {
        await Self.deleteUsername(username: username)
    }
}

