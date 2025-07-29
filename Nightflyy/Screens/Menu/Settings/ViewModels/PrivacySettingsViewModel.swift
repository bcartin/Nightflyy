//
//  PrivacySettingsViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/11/25.
//

import SwiftUI

@Observable
class PrivacySettingsViewModel {
    
    var error: Error?
    
    var account: Account
    var isLoading: Bool = false
    
    init() {
        self.account =  AccountManager.shared.account ?? Account()
    }
    
    var isPrivateAccount: Bool {
        get {
            return account.accountIsPrivate ?? false
        }
        set(newValue) {
            account.accountIsPrivate = newValue
        }
    }
    
    func saveChanges() {
        Task {
                self.isLoading = true
                do {
                    try account.save()
                    try? await Task.sleep(for: .seconds(2))
                    isLoading = false
                    AccountManager.shared.account = self.account
                    General.showSavedMessage()
                }
                catch {
                    self.error = error
                }
            }
    }
    
}
