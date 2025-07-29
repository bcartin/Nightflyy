//
//  EditProfileViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/8/25.
//

import Foundation
import SwiftUI

@Observable
class EditProfileViewModel {
    
    var account: Account
    var isLoading: Bool = false
    var goToScreen: Bool = false
    var selectedGoToScreen: NavigateTo?
    var selectedImage: Image?
    var uiImage: UIImage?
    var error: Error?
    var currentUsername: String?
    
    init() {
        self.account =  AccountManager.shared.account ?? Account()
        currentUsername = AccountManager.shared.account?.username
    }
    
    var username: String {
        get {
            return account.username ?? ""
        }
        set(newUsername) {
            account.username = newUsername
        }
    }
    
    var email: String {
        get {
            return account.email ?? ""
        }
        set(newValue) {
            account.email = newValue
        }
    }
    
    var password: String = "password"
    
    var name: String {
        get {
            return account.name ?? ""
        }
        set(newValue) {
            account.name = newValue
        }
    }
    
    var gender: String {
        get {
            return Gender(x: account.gender)?.rawValue ?? ""
        }
        set(newValue) {
            account.gender = Gender(rawValue: newValue)?.intValue
        }
    }
    
    var dob: String {
        get {
            return account.dob ?? ""
        }
        set(newValue) {
            account.dob = newValue
        }
    }
    
    var convertedDob: Date {
        get {
            return dob.dateValue(format: "MMM dd, yyyy") ?? Date()
        }
        set(newValue) {
            self.dob = newValue.stringValue(format: "MMM dd, yyyy")
        }
    }
    
    var bio: String {
        get {
            return account.bio ?? ""
        }
        set(newValue) {
            account.bio = newValue
        }
    }
    
    var currentCity: String {
        get {
            return account.city ?? ""
        }
        set(newValue) {
            account.city = newValue
        }
    }
    
    var phoneNumber: String {
        get {
            return account.phoneNumber ?? ""
        }
        set(newValue) {
            account.phoneNumber = newValue
        }
    }
    
    var usernameDidChange: Bool {
        currentUsername != username
    }
    
    var profileImageDidChange: Bool {
        uiImage != nil
    }
    
    func saveChanges() {
        Task {
            if await validateData() {
                self.isLoading = true
                do {
                    await updateProfileImage()
                    try account.save()
                    await updateUsernamesCollection()
                    await updateFirebaseUser()
                    updateSearchIndex()
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
    
    func updateProfileImage() async {
        if let image = uiImage {
            do {
                let storageManager = StorageManager()
                if let oldImageUrl = account.profileImageUrl {
                    try await storageManager.deletePhoto(url: oldImageUrl)
                }
                let imageUrl = try await storageManager.saveProfilePhoto(photo: image)
                account.profileImageUrl = imageUrl
            }
            catch {
                self.error = error
            }
        }
    }
    
    func updateUsernamesCollection() async {
        if usernameDidChange {
            await UsernamesClient.saveUsername(username: username)
            await UsernamesClient.deleteUsername(username: currentUsername ?? "")
        }
    }
    
    func updateFirebaseUser() async {
        if usernameDidChange || profileImageDidChange {
            await FirebaseFunctionsManager.shared.updateDisplayNameAndPhotoUrl(account: account)
        }
    }
    
    func updateSearchIndex() {
        if usernameDidChange {
            try? SearchManager.shared.updateSearchIndex(objectID: account.uid, objectType: .person, name: account.name, username: username, venue: nil)
        }
    }
    
    func setImage(data: Data) {
        if let image = UIImage(data: data) {
            self.uiImage = image
            self.selectedImage = Image(uiImage: image)
        }
    }
    
    func validateData() async -> Bool {
        // Validate Username
        if username.isEmpty || name.isEmpty {
            error = AccountError.missingRequiredFields
            return false
        }
        
        if username.first == "." {
            error = AccountError.invalidUsername
            return false
        }
        
        if usernameDidChange {
            if !(await UsernamesClient.isUsernameAvailable(username)) {
                error = AccountError.usernameTaken
                return false
            }
        }
        
        return true
    }
}

extension EditProfileViewModel {
    
    enum NavigateTo {
        case gender
        case dob
        case bio
        case changePassword
    }
    
    func goToScreen(_ navigateTo: NavigateTo) {
        goToScreen = true
        selectedGoToScreen = navigateTo
    }
}
