//
//  FirebaseFunctionsManager.swift
//  NightflyyAdmin
//
//  Created by Bernie Cartin on 3/21/25.
//

import Foundation
import FirebaseFunctions
import OSLog

class FirebaseFunctionsManager {
    
    static let shared = FirebaseFunctionsManager()
    
    private init() {}
    
    lazy var functions = Functions.functions()
    
    func updateDisplayNameAndPhotoUrl(account: Account) async {
        let info = ["displayName":account.username, "photoURL":account.profileImageUrl]
        self.functions.httpsCallable("updateUser").call(["uid":account.uid, "info":info]) { result, error in
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    Logger.general.error("Error updating user display name/photo: \(error.localizedDescription)")
                }
            }
            else {
                Logger.general.info("User display name and photo updated successfully")
            }
        }
    }
    
    func deleteUser(uid: String) {
        self.functions.httpsCallable("deleteUser").call(["uid":uid]) { result, error in
            if let error = error as NSError? {
              if error.domain == FunctionsErrorDomain {
                  Logger.general.error("Error deleting user \(uid): \(error.localizedDescription)")
              }
            }
            else {
                Logger.general.info("User \(uid) deleted successfully")
            }
        }
    }
}
