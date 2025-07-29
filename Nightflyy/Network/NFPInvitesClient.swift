//
//  NFPInvitesClient.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/28/25.
//

import Foundation
import FirebaseFirestore

class NFPInvitesClient {
    
    static func addInvite(to venueId: String) async throws {
        guard let uid = AccountManager.shared.account?.uid else { return }
        try await FirebaseManager.shared.db.collection(FirestoreCollections.Accounts.value).document(venueId).collection(FirestoreCollections.NFPInvites.value).addDocument(data: ["account_id": uid, "date": Date()])
    }
    
    static func deleteInvites() async throws {
        guard let uid = AccountManager.shared.account?.uid else { return }
        let inviteSnapshots = try await FirebaseManager.shared.db.collectionGroup(FirestoreCollections.NFPInvites.value).whereField("account_id", isEqualTo: uid).getDocuments()
        inviteSnapshots.documents.forEach { $0.reference.delete() }
    }
}
