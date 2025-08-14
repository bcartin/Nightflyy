//
//  SignupViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/21/25.
//

import Foundation
import SwiftUI
import AuthenticationServices
import FirebaseAuth

enum SignupScreen: Hashable {
    case account
    case profile
    case location
    case paywall
    case gender
    case dob
    case forgotPassword
}

enum SignupSheetView: Hashable {
    case terms
    case privacy
}

@Observable
class SignupViewModel {
    
    var account: Account?
    
    var navigationPath: [SignupScreen] = []
    var error: Error? {
        didSet {
            AppState.shared.isLoading = false
        }
    }
    var presentSheet: Bool = false
    var sheetView: SignupSheetView?
    var signupMethod: SignUpMethod?
    
    //Apple Sign In Fields
    var appleIDCredential: ASAuthorizationAppleIDCredential?
    var nonce: String = AuthenticationManager.shared.randomNonceString()
    
    //Account View Fields
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    
    //Profile View Fields
    var selectedImage: Image?
    var uiImage: UIImage?
    var username: String = ""
    var name: String = ""
    var gender: String = ""
    var dob: String = ""
    
    var convertedDob: Date {
        get {
            return dob.dateValue(format: "MMM dd, yyyy") ?? Date()
        }
        set(newValue) {
            self.dob = newValue.stringValue(format: "MMM dd, yyyy")
        }
    }
    
    func signUp() async {
        AuthenticationManager.shared.isSigningUp = true
        AppState.shared.isLoading = true
        if await !validateProfileFields() {
            return
        }
        switch signupMethod {
        case .apple:
            await signupWithApple()
        case .nightflyy:
            await signupWithNightflyy()
        case .none:
            return
        }
    }
    
    func signupWithNightflyy() async {
        do {
            let uid = try await AuthenticationManager.shared.createUser(email: email, password: password)
            try await createAccount(uid: uid)
        }
        catch {
            print(error.localizedDescription)
            self.error = error
        }
    }
    
    func signupWithApple() async {
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
            let uid = try await AuthenticationManager.shared.signIn(with: credential)
            try await createAccount(uid: uid)
        }
        catch {
            print(error.localizedDescription)
            self.error = error
        }
    }
    
    func createAccount(uid: String) async throws {
        account = Account(id: uid,
                          accountIsPrivate: false,
                          accountType: .personal,
                          badgeCount: 0,
                          bonusCreditDate: nil,
                          dob: dob,
                          email: email,
                          gender: Gender(rawValue: gender)?.intValue,
                          name: name,
                          notificationSettings: NotificationSettings(),
                          username: username)
        try await updateProfileImage()
        try account?.save()
        await UsernamesClient.saveUsername(username: username)
        
        // Update search Index
        try SearchManager.shared.updateSearchIndex(objectID: uid, objectType: .person, name: name, username: username, venue: nil)
        
        // Create contact in sendgrid
        try await SendgridManager.createContactInSendgrid(account: account!, lists: [.ALL])
        
        MainCoordinator().initialAppSetup()
        
        //TODO: Add follow to NF and Jameel
        AppState.shared.isLoading = false
        self.goToScreen(.location)
    }
    
    func goToScreen(_ navigateTo: SignupScreen) {
        navigationPath.append(navigateTo)
    }
    
    func setSignupMethod(_ method: SignUpMethod) {
        self.signupMethod = method
    }
    
}

extension SignupViewModel { //MARK: Account View Functions
    
    func validateAccountFields() {
        if email.isEmpty || password.isEmpty {
            error = AccountError.missingRequiredFields
            return
        }
        if !validate(eMailAddress: email) {
            error = AccountError.invalidEmail
            return
        }
        if !validatePassword() {
            return
        }
        goToScreen(.profile)
    }
    
    private func validate(eMailAddress: String) -> Bool {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: eMailAddress)
    }
    
    private func validatePassword() -> Bool {
        if password != confirmPassword {
            error = AccountError.passwordsDontMatch
            return false
        }
        
        if password.count < 8 {
            error = AccountError.passwordTooShort
            return false
        }
        
        return true
    }
    
}

extension SignupViewModel { //MARK: Profile View Functions
    
    func presentSheet( _ sheetView: SignupSheetView) {
        self.sheetView = sheetView
        presentSheet = true
    }
    
    func validateProfileFields() async -> Bool {
        if username.isEmpty || name.isEmpty || gender.isEmpty || dob.isEmpty {
            error = AccountError.missingRequiredFields
            return false
        }
        if username.first == "." {
            error = AccountError.invalidUsername
            return false
        }
        let isUserNameAvailable = await UsernamesClient.isUsernameAvailable(username)
        if !isUserNameAvailable {
            error = AccountError.usernameTaken
            return false
        }
        let age = Calendar.current.dateComponents([.year], from: convertedDob, to: Date()).year!
        if age < 18 {
            error = AccountError.invalidAge
            return false
        }
        return true
    }
    
    func updateProfileImage() async throws {
        if let image = uiImage {
            let storageManager = StorageManager()
            let imageUrl = try await storageManager.saveProfilePhoto(photo: image)
            account?.profileImageUrl = imageUrl
        }
    }
    
    func setImage(data: Data) {
        if let image = UIImage(data: data) {
            self.uiImage = image
            self.selectedImage = Image(uiImage: image)
        }
    }
}


