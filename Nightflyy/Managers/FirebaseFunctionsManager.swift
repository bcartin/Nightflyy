//
//  FirebaseFunctionsManager.swift
//  NightflyyAdmin
//
//  Created by Bernie Cartin on 3/21/25.
//

import Foundation
import FirebaseFunctions

class FirebaseFunctionsManager {
    
    static let shared = FirebaseFunctionsManager()
    
    private init() {}
    
    lazy var functions = Functions.functions()
    
    func updateDisplayNameAndPhotoUrl(account: Account) async {
        guard let username = account.username else { return }
        let info = ["displayName":account.username, "photoURL":account.profileImageUrl]
        self.functions.httpsCallable("updateUser").call(["uid":account.uid, "info":info]) { result, error in
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    let message = error.localizedDescription
                    print(message)
                }
            }
            else {
                print("User Updated")
            }
        }
    }
    
    func deleteUser(uid: String) {
        self.functions.httpsCallable("deleteUser").call(["uid":uid]) { result, error in
            if let error = error as NSError? {
              if error.domain == FunctionsErrorDomain {
                let message = error.localizedDescription
                print(message)
              }
            }
            else {
                print("User \(uid) Deleted")
            }
        }
    }
}
