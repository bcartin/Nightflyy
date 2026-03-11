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
    
    static let shared = AccountClient()
    
    static func saveCustomData(uid: String, data: [String: Any]) {
        FirebaseManager.shared.db.collection(FirestoreCollections.Accounts.value).document(uid).setData(data, merge: true)
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
            Logger.network.error("Error fetching venues for city: \(error.localizedDescription)")
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
            Logger.network.error("Error fetching Nightflyy Plus providers: \(error.localizedDescription)")
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
            Logger.network.error("Error fetching account reviews for \(uid): \(error.localizedDescription)")
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
            Logger.network.error("Error fetching review count for \(uid): \(error.localizedDescription)")
            return 0
        }
    }
    
    static func fetchVenueByRedemptionCode(code: String) async throws -> Account? {
        let query = FirebaseManager.shared.db.collection(FirestoreCollections.Accounts.value)
            .whereField(FirestoreCollections.Accounts.redemptionCode, isEqualTo: code)
        let snapshot = try await query.getDocuments()
        let document = snapshot.documents.first
        return try document?.data(as: Account.self)
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
    
    static func fetchNightflyyPlusMember() async -> [Account] {
        var accounts: [Account] = .init()
        do {
            let dbRef = FirebaseManager.shared.db.collection(FirestoreCollections.Accounts.value)
                .whereField(FirestoreCollections.Accounts.plus_member, isEqualTo: true)
            let snapshot = try await dbRef.getDocuments()
            accounts = try snapshot.documents.map({ document in
                return try document.data(as: Account.self)
            })
            return accounts.sorted { $0.name ?? "" < $1.name ?? "" }
        }
        catch {
            Logger.network.error("Error fetching Nightflyy Plus members: \(error.localizedDescription)")
            return accounts
        }
    }
    
    private static func addToArrayField(accountId: String, field: String, value: String) async throws {
        try await FirebaseManager.shared.db
            .collection(FirestoreCollections.Accounts.value)
            .document(accountId)
            .updateData([field: FieldValue.arrayUnion([value])])
    }
    
    private static func removeFromArrayField(accountId: String, field: String, value: String) async throws {
        try await FirebaseManager.shared.db
            .collection(FirestoreCollections.Accounts.value)
            .document(accountId)
            .updateData([field: FieldValue.arrayRemove([value])])
    }
    
    static func requestToFollowAccount(accountToRequest: String, requestingAccount: String) async throws {
        try await addToArrayField(accountId: requestingAccount, field: FirestoreCollections.Accounts.requested, value: accountToRequest)
    }
    
    static func followAccount(accountToFollow: String, followingAccount: String) async throws {
        try await addToArrayField(accountId: accountToFollow, field: FirestoreCollections.Accounts.followers, value: followingAccount)
        try await addToArrayField(accountId: followingAccount, field: FirestoreCollections.Accounts.following, value: accountToFollow)
    }
    
    static func unfollowAccount(accountToUnfollow: String, followingAccount: String) async throws {
        try await removeFromArrayField(accountId: accountToUnfollow, field: FirestoreCollections.Accounts.followers, value: followingAccount)
        try await removeFromArrayField(accountId: followingAccount, field: FirestoreCollections.Accounts.following, value: accountToUnfollow)
    }


    
}
// MARK: - AccountClientProtocol

extension AccountClient: AccountClientProtocol {
    func saveCustomData(uid: String, data: [String: Any]) {
        Self.saveCustomData(uid: uid, data: data)
    }
    
    func fetchAccount(accountId: String) async -> Account? {
        await Self.fetchAccount(accountId: accountId)
    }
    
    func fetchAccountGroup(accountIds: [String]) async -> [Account] {
        await Self.fetchAccountGroup(accountIds: accountIds)
    }
    
    func fetchVenuesFrom(city: City) async -> [Account] {
        await Self.fetchVenuesFrom(city: city)
    }
    
    func fetchNightflyyPlusProviders() async -> [Account] {
        await Self.fetchNightflyyPlusProviders()
    }
    
    func fetchAccountReviews(for uid: String) async -> [Review] {
        await Self.fetchAccountReviews(for: uid)
    }
    
    func getAccountReviewCount(for uid: String) async -> Int {
        await Self.getAccountReviewCount(for: uid)
    }
    
    func fetchVenueByRedemptionCode(code: String) async throws -> Account? {
        try await Self.fetchVenueByRedemptionCode(code: code)
    }
    
    func removeFromRequested(accountId: String) async throws {
        try await Self.removeFromRequested(accountId: accountId)
    }
    
    func submitReview(accountId: String, review: Review) throws {
        try Self.submitReview(accountId: accountId, review: review)
    }
    
    func fetchNightflyyPlusMember() async -> [Account] {
        await Self.fetchNightflyyPlusMember()
    }
    
    func followAccount(accountToFollow: String, followingAccount: String) async throws {
        try await Self.followAccount(accountToFollow: accountToFollow, followingAccount: followingAccount)
    }
    
    func unfollowAccount(accountToUnfollow: String, followingAccount: String) async throws {
        try await Self.unfollowAccount(accountToUnfollow: accountToUnfollow, followingAccount: followingAccount)
    }
    
    func requestToFollowAccount(accountToRequest: String, requestingAccount: String) async throws {
        try await Self.requestToFollowAccount(accountToRequest: accountToRequest, requestingAccount: requestingAccount)
    }
}

