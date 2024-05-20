//
//  AccountManager.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/7/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class AccountService {
    
    private let accountCache: NSCache<NSString, Account> = NSCache()
    
    static func loadAccount(uid: String) async -> Result<Account, Error> {
        do {
            guard let account =  try await FirebaseManager.shared.getDocument(collection: C_ACCOUNTS, documentId: uid, Account.self) else { return .failure(NetworkError.noRecordFound) }
            return .success(account)
        }
        catch {
            return .failure(error)
        }
    }
    
}
