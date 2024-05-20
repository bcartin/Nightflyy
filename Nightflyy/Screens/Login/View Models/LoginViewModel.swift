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

@Observable
class LoginViewModel {
    
    var email: String = ""
    var password: String = ""
    var nonce: String = AuthenticationManager.shared.randomNonceString()
    var appleIDCredential: ASAuthorizationAppleIDCredential?
    
    var error: Error?
    
    func logInWithEmail() {
        Task { @MainActor in
            AuthenticationManager.shared.isSigningUp = false
            AppState.shared.isLoading = true
            let result = await AuthenticationManager.shared.signIn(email: email, password: password)
            AppState.shared.isLoading = false
            switch result {
            case .success(let uid):
                Logger.auth.info("Successfully logged in for user \(uid)")
                MainCoordinator().initialAppSetup()
            case .failure(let error):
                self.error = error
                Logger.auth.error("Error login in.")
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
        }
        catch {
            print(error.localizedDescription)
            self.error = error
        }
    }
}
