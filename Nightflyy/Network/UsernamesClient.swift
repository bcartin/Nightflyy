//
//  UsernamesClient.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/10/25.
//

import SwiftUI
import FirebaseFirestore

class UsernamesClient {
    
    static func isUsernameAvailable(_ username: String) async -> Bool {
        do {
            let reference = FirebaseManager.shared.db.collection(FirestoreCollections.Usernames.value)
                .whereField(FirestoreCollections.Usernames.usernames, arrayContains: username)
            let snapshot = try await reference.getDocuments()
            return snapshot.isEmpty
        }
        catch {
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
            print("Error saving username: \(error)")
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
            print("Error deleting username: \(error)")
        }
    }
    
}
