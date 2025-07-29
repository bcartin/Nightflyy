//
//  ChangePasswordViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/11/25.
//

import Foundation
import SwiftUI

@Observable
class ChangePasswordViewModel {
    
    var currentPassword: String = ""
    var newPassword: String = ""
    var confirmNewPassword: String = ""
    var error: Error?
    
    
    func changePassword() {
        if validatePasswords() {
            if let email = AuthenticationManager.shared.currentUser?.email {
                Task {
                    let result = await AuthenticationManager.shared.signIn(email: email, password: currentPassword)
                    switch result {
                        
                    case .success(_):
                        do {
                            try await AuthenticationManager.shared.updatePassword(newPassword: newPassword)
                            General.showSuccessMessage(message: "Password Changed Successfully", imageName: "checkmark.circle.fill")
                        }
                        catch {
                            self.error = error
                        }
                    case .failure(let error):
                        self.error = error
                    }
                }
            }
        }
    }
    
    func validatePasswords() -> Bool {
        if currentPassword.isEmpty || newPassword.isEmpty || confirmNewPassword.isEmpty {
            error = AccountError.passwordsDontMatch
            return false
        }
        
        if newPassword != confirmNewPassword {
            error = AccountError.passwordsDontMatch
            return false
        }
        
        if newPassword.count < 8 {
            error = AccountError.passwordTooShort
            return false
        }
        
        return true
    }
    
}
