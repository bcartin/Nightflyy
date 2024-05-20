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
    
}
