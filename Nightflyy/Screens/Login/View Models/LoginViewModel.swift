//
//  LoginViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/7/24.
//

import SwiftUI
import OSLog
import AuthenticationServices
import FirebaseAuth

@Observable @MainActor
class LoginViewModel {
    
    var email: String = ""
    var password: String = ""
    var nonce: String = AuthenticationManager.shared.randomNonceString()
    var appleIDCredential: ASAuthorizationAppleIDCredential?
    var presentEmailSentAlert: Bool = false
    
    var error: Error?
    
    func logInWithEmail() {
        Task {
            AuthenticationManager.shared.isSigningUp = false
            AppState.shared.isLoading = true
            do {
                let uid = try await AuthenticationManager.shared.signIn(email: email, password: password)
                AppState.shared.isLoading = false
                Logger.auth.info("Successfully logged in for user \(uid)")
                MainCoordinator().initialAppSetup()
                try await PushNotificationsManager.shared.requestPermission()
            } catch {
                AppState.shared.isLoading = false
                self.error = error
                Logger.auth.error("Error logging in: \(error.localizedDescription)")
            }
        }
    }
    
    func signInWithApple() async {
        AuthenticationManager.shared.isSigningUp = false
        guard let appleIDToken = appleIDCredential?.identityToken else {
            error = SignupError.cannotProcessRequest
            return
        }
        
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            error = SignupError.cannotProcessRequest
            return
        }
        
        let credential = OAuthProvider.appleCredential(withIDToken: idTokenString, rawNonce: nonce, fullName: appleIDCredential?.fullName)
        
        do {
            _ = try await AuthenticationManager.shared.signIn(with: credential)
            MainCoordinator().initialAppSetup()
            try await PushNotificationsManager.shared.requestPermission()
        }
        catch {
            Logger.auth.error("Error signing in with Apple: \(error.localizedDescription)")
            self.error = error
        }
    }
    
    func handleForgotPassword() {
        if email.isEmpty {
            error = AccountError.invalidEmail
            return
        }
        Task {
            do {
                try await AuthenticationManager.shared.forgotPassword(email: email)
                presentEmailSentAlert = true
            }
            catch {
                self.error = error
            }
        }
    }
}
