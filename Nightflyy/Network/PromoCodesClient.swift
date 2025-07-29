//
//  PromoCodesClient.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/27/25.
//


import Foundation
import FirebaseFirestore
import OSLog

class PromoCodesClient {
    
    static func codeIsValid(code: String) async -> Bool {
        do {
            let query = FirebaseManager.shared.db.collection(FirestoreCollections.BACodes.value)
                .whereField(FirestoreCollections.BACodes.code, isEqualTo: code.uppercased())
                .whereField(FirestoreCollections.BACodes.isEnabled, isEqualTo: true)
            let snapshot = try await query.getDocuments()
            return !snapshot.documents.isEmpty
        }
        catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    static func addRedemption(code: String) {
        guard let uid = AccountManager.shared.account?.uid, let username = AccountManager.shared.account?.username else { return }
        let ref = FirebaseManager.shared.db.collection(FirestoreCollections.BACodes.value).document(code)
        let redemption = ["uid" : uid, "username": username, "date": Date()] as [String : Any]
        ref.updateData([FirestoreCollections.BACodes.redemptions : FieldValue.arrayUnion([redemption])])
        
    }
    
}



