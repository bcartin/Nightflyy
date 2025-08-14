//
//  AuthenticationManager.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/24/24.
//

import Foundation
import FirebaseAuth
import CryptoKit

@Observable
class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    
    private init() {}
    
    var isSignedIn: Bool = false
    var isSigningUp: Bool = false
    
    var currentUser: User? {
        Auth.auth().currentUser
    }
            
    func signIn(email: String, password: String) async -> Result<String, Error> {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            return .success(result.user.uid)
        }
        catch {
            return .failure(error)
        }
    }
    
    func signIn(with credential: OAuthCredential) async throws -> String {
        let result = try await Auth.auth().signIn(with: credential)
        return result.user.uid
    }
    
    func updatePassword(newPassword: String) async throws {
        try await Auth.auth().currentUser?.updatePassword(to: newPassword)
    }
    
    func forgotPassword(email: String) async throws{
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func logOut() throws {
        try Auth.auth().signOut()
        self.isSignedIn = false
    }
    
    func checkAuthState() {
        _ = Auth.auth().addStateDidChangeListener { _, user in
            self.isSignedIn = user != nil
            if user == nil {
                AppState.shared.showSplashScreen = false
            }
        }
    }
    
    func createUser(email: String, password: String) async throws -> String {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        return result.user.uid
    }
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
}
