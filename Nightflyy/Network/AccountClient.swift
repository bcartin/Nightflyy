//
//  AccountClient.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/7/24.
//

import Foundation
import FirebaseFirestore
import OSLog

class AccountClient {
    
    static func saveCustomData(uid: String, data: [String: Any]) {
        FirebaseManager.shared.db.collection(FirestoreCollections.Accounts.value).document(uid).setData(data, merge: true)
    }
    
    static func fetchAccount(uid: String) async -> Result<Account, Error> {
        if let cached = firebaseCache[uid] {
            switch cached {
            case .account(let account):
                Logger.network.info("\(Logger.Category.Network.rawValue): Fetched account \(uid) from cache.")
                return .success(account)
            default:
                return .failure(NetworkError.noRecordFound)
            }
        }
        do {
            guard let account =  try await FirebaseManager.shared.getDocument(collection: FirestoreCollections.Accounts.value, documentId: uid, Account.self) else { return .failure(NetworkError.noRecordFound) }
            firebaseCache[uid] = .account(account)
            Logger.network.info("\(Logger.Category.Network.rawValue): Fetched account \(uid) from firebase.")
            return .success(account)
        }
        catch {
            Logger.network.error("\(Logger.Category.Network.rawValue): Error fetching account \(uid) from firebase.")
            return .failure(error)
        }
    }
    
    static func fetchAccount(accountId: String) async -> Account? {
        if let cached = firebaseCache[accountId] {
            switch cached {
            case .account(let account):
                Logger.network.info("\(Logger.Category.Network.rawValue): Fetched account \(accountId) from cache.")
                return account
            default:
                return nil
            }
        }
        do {
            let account = try await FirebaseManager.shared.getDocument(collection: FirestoreCollections.Accounts.value, documentId: accountId, Account.self)
            if let account = account {
                firebaseCache[accountId] = .account(account)
            }
            Logger.network.info("\(Logger.Category.Network.rawValue): Fetched account \(accountId) from firebase.")
            return account
        }
        catch {
            Logger.network.error("\(Logger.Category.Network.rawValue): Error fetching account \(accountId): \(error.localizedDescription)")
            return nil
        }
    }
    
    static func fetchAccountGroup(accountIds: [String]) async -> [Account] {
        var accounts: [Account] = .init()
        await withTaskGroup(of: Account?.self) { group in
            for uid in accountIds {
                group.addTask {
                    return await fetchAccount(accountId: uid)
                }
            }
            for await account in group {
                if let account = account {
                    accounts.append(account)
                }
            }
        }
        return accounts
    }
    
    static func fetchVenuesFrom(city: City) async -> [Account] {
        var accounts: [Account] = .init()
        do {
            let dbRef = FirebaseManager.shared.db.collection(FirestoreCollections.Accounts.value)
                .whereField("city", isEqualTo: city.city)
                .whereField("state", isEqualTo: city.state)
                .whereField("account_type", isEqualTo: "venue")
            let snapshot = try await dbRef.getDocuments()
            accounts = try snapshot.documents.map({ document in
                return try document.data(as: Account.self)
            })
            return accounts
        }
        catch {
            print(error.localizedDescription)
            return accounts
        }
        
    }
    
    static func fetchNightflyyPlusProviders() async -> [Account] {
        var accounts: [Account] = .init()
        do {
            let dbRef = FirebaseManager.shared.db.collection(FirestoreCollections.Accounts.value)
                .whereField(FirestoreCollections.Accounts.plusProvider, isEqualTo: true)
            let snapshot = try await dbRef.getDocuments()
            accounts = try snapshot.documents.map({ document in
                return try document.data(as: Account.self)
            })
            return accounts.sorted { $0.name ?? "" < $1.name ?? "" }
        }
        catch {
            print(error.localizedDescription)
            return accounts
        }
    }
    
    static func fetchAccountReviews(for uid: String) async -> [Review] {
        do {
            var reviews: [Review] = .init()
            let dbRef = FirebaseManager.shared.db.collection(FirestoreCollections.Accounts.value).document(uid).collection(FirestoreCollections.Accounts.reviews)
            let snapshot = try await dbRef.getDocuments()
            reviews = try snapshot.documents.map({ document in
                return try document.data(as: Review.self)
            })
            return reviews
        }
        catch {
            return []
        }
    }
    
    static func getAccountReviewCount(for uid: String) async -> Int {
        let query = FirebaseManager.shared.db.collection(FirestoreCollections.Accounts.value).document(uid).collection(FirestoreCollections.Accounts.reviews)
        let countQuery = query.count
        do {
            let snapshot = try await countQuery.getAggregation(source: .server)
            return snapshot.count as? Int ?? 0
        }
        catch {
            return 0
        }
    }
    
    static func fetchVenueByRedemptionCode(code: String) async throws -> Account? {
        do {
            let query = FirebaseManager.shared.db.collection(FirestoreCollections.Accounts.value)
                .whereField(FirestoreCollections.Accounts.redemptionCode, isEqualTo: code)
            let snapshot = try await query.getDocuments()
            let document = snapshot.documents.first
            let account = try document?.data(as: Account.self)
            return account
        }
        catch {
           throw error
        }
    }
    
    static func removeFromRequested(accountId: String) async throws {
        guard let uid = AccountManager.shared.account?.uid else { return }
        try await FirebaseManager.shared.db
            .collection(FirestoreCollections.Accounts.value)
            .document(accountId)
            .updateData([
                FirestoreCollections.Accounts.requested: FieldValue.arrayRemove([uid])
            ])
    }
    
    static func submitReview(accountId: String, review: Review) throws {
        try FirebaseManager.shared.db.collection(FirestoreCollections.Accounts.value).document(accountId).collection(FirestoreCollections.Accounts.reviews).addDocument(from: review)
    }
    
}
