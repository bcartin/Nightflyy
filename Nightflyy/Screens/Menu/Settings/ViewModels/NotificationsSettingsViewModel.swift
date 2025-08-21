//
//  NotificationsSettingsViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/11/25.
//

import SwiftUI

@Observable
class NotificationsSettingsViewModel {
    
    var error: Error?
    
    var account: Account
    var isLoading: Bool = false
    
    init() {
        self.account =  AccountManager.shared.account ?? Account()
    }
    
    var allowPushNotificaitons: Bool {
        get {
            PushNotificationsManager.shared.authorizationStatus == .authorized
        }
        set(newValue) {
            Task {
                try? await PushNotificationsManager.shared.requestPermission()
            }
        }
    }
    
    var followStarted: Bool {
        get {
            account.notificationSettings?.followStart ?? true
        }
        set(newValue) {
            account.notificationSettings?.followStart = newValue
        }
    }
    
    var followRequest: Bool {
        get {
            account.notificationSettings?.followRequest ?? true
        }
        set(newValue) {
            account.notificationSettings?.followRequest = newValue
        }
    }
    
    var followRequestAccepted: Bool {
        get {
            account.notificationSettings?.followAccepted ?? true
        }
        set(newValue) {
            account.notificationSettings?.followAccepted = newValue
        }
    }
    
    var alert: Bool {
        get {
            account.notificationSettings?.alertReceived ?? true
        }
        set(newValue) {
            account.notificationSettings?.alertReceived = newValue
        }
    }
    
    var directMessage: Bool {
        get {
            account.notificationSettings?.message ?? true
        }
        set(newValue) {
            account.notificationSettings?.message = newValue
        }
    }
    
    var eventInvite: Bool {
        get {
            account.notificationSettings?.inviteToEvent ?? true
        }
        set(newValue) {
            account.notificationSettings?.inviteToEvent = newValue
        }
    }
    
    var eventRsvp: Bool {
        get {
            account.notificationSettings?.eventGoing ?? true
        }
        set(newValue) {
            account.notificationSettings?.eventGoing = newValue
        }
    }
    
    var chatroomComment: Bool {
        get {
            account.notificationSettings?.eventComment ?? true
        }
        set(newValue) {
            account.notificationSettings?.eventComment = newValue
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
