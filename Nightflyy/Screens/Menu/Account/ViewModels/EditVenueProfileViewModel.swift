//
//  EditVenueProfileViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/23/25.
//

import Foundation
import SwiftUI

@Observable
class EditVenueProfileViewModel {
    
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
    
    var bio: String {
        get {
            return account.bio ?? ""
        }
        set(newValue) {
            account.bio = newValue
        }
    }
    
    var venueType: String {
        get {
            return account.venueType ?? ""
        }
        set(newValue) {
            account.venueType = newValue
        }
    }
    
    var address: String {
        get {
            return account.address ?? ""
        }
        set(newValue) {
            account.address = newValue
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
    
    var businessEmail: String {
        get {
            return account.businessEmail ?? ""
        }
        set(newValue) {
            account.businessEmail = newValue
        }
    }
    
    var website: String {
        get {
            return account.website ?? ""
        }
        set(newValue) {
            account.website = newValue
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
            try? SearchManager.shared.updateSearchIndex(objectID: account.uid, objectType: .venue, name: account.name, username: username, venue: nil)
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
        
        if phoneNumber.isEmpty || businessEmail.isEmpty {
            error = AccountError.missingRequiredFields
            return false
        }
        
        return true
    }
}

extension EditVenueProfileViewModel {
    
    enum NavigateTo {
        case venueType
        case bio
        case changePassword
        case address
    }
    
    func goToScreen(_ navigateTo: NavigateTo) {
        goToScreen = true
        selectedGoToScreen = navigateTo
    }
}
