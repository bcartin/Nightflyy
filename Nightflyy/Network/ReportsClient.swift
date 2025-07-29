//
//  ReportsClient.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/16/25.
//

import Foundation
import FirebaseFirestore
import OSLog

class ReportsClient {
    
    static func submitReport(report: Report) throws {
        let db = FirebaseManager.shared.db
        try db.collection(FirestoreCollections.Reports.value).addDocument(from: report)
    }
    
    static func blockAccount(accountId: String) async throws {
        guard let uid = AccountManager.shared.account?.uid else {return}
        try await FirebaseManager.shared.db
            .collection(FirestoreCollections.Accounts.value)
            .document(uid)
            .updateData([
                FirestoreCollections.Accounts.blocked: FieldValue.arrayUnion([accountId])
            ])
        try await FirebaseManager.shared.db
            .collection(FirestoreCollections.Accounts.value)
            .document(accountId)
            .updateData([
                FirestoreCollections.Accounts.blockedBy: FieldValue.arrayUnion([uid])
            ])
    }
    
}
