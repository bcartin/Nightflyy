//
//  AccountManager.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/7/24.
//

import SwiftUI
import OSLog

@Observable
class AccountManager: AccountManaging {
    
    static let shared = AccountManager()
    
    var account: Account?
    
    private let accountClient: any AccountClientProtocol
    private let notificationClient: any AppNotificationClientProtocol
    
    private init(
        accountClient: any AccountClientProtocol = AccountClient.shared,
        notificationClient: any AppNotificationClientProtocol = AppNotificationClient.shared
    ) {
        self.accountClient = accountClient
        self.notificationClient = notificationClient
    }
    
    var isPersonalAccount: Bool {
        self.account?.accountType == .personal
    }
    
    var isPlusMember: Bool {
        return true
//        account?.hasActiveSubscription ?? false
    }
    
    var isPlusProvider: Bool {
        account?.isProvider ?? false
    }
    
    var isAdmin: Bool {
        self.account?.isAdmin ?? false
    }
    
    func saveAccount() {
        do {
            try account?.save()
        }
        catch {
            Logger.general.error("Error saving account: \(error.localizedDescription)")
        }
    }
    
    func fetchAccount(uid: String) async {
        if let account = await accountClient.fetchAccount(accountId: uid) {
            self.account = account
            Logger.network.info("User account successfully loaded")
        } else {
            Logger.network.error("Error fetching user account.")
        }
    }
    
    @discardableResult func followAccount(accountToFollow: Account) async throws -> Account {
        
        guard let uid = self.account?.uid else { return accountToFollow }
        
        var updatedAccount = accountToFollow
        try await accountClient.followAccount(accountToFollow: updatedAccount.uid, followingAccount: uid)
        self.account?.following?.append(updatedAccount.uid)
        updatedAccount.followers?.append(uid)
        
        let notification = AppNotification(sender: uid, date: Date(), type: .follow_start, notificationData: NotificationData(profile_image_url: account?.profileImageUrl, username: account?.username))
        try notificationClient.saveNotification(for: updatedAccount.uid, notification: notification)
        return updatedAccount
    }
    
    @discardableResult func unfollowAccount(accountToFollow: Account) async throws -> Account {
        
        guard let uid = self.account?.uid else { return accountToFollow }
        
        var updatedAccount = accountToFollow
        try await accountClient.unfollowAccount(accountToUnfollow: updatedAccount.uid, followingAccount: uid)
        
        if let index1 = account?.following?.firstIndex(of: updatedAccount.uid) {
            self.account?.following?.remove(at: index1)
        }
        if let index2 = updatedAccount.followers?.firstIndex(of: uid) {
            updatedAccount.followers?.remove(at: index2)
        }
        return updatedAccount
    }
    
    func requestToFollowAccount(accountId: String) async throws {
        guard let uid = self.account?.uid else { return }
        try await accountClient.requestToFollowAccount(accountToRequest: accountId, requestingAccount: uid)
        self.account?.requested?.append(accountId)
        try self.account?.save()
        
        let notification = AppNotification(sender: uid, date: Date(), type: .follow_request, notificationData: NotificationData(profile_image_url: account?.profileImageUrl, username: account?.username))
        try notificationClient.saveNotification(for: accountId, notification: notification)
    }
    
    @discardableResult func acceptFollowRequest(from newFollower: Account) async throws -> Account {
        guard let uid = self.account?.uid else { return newFollower }
        try await accountClient.followAccount(accountToFollow: uid, followingAccount: newFollower.uid)
        
        var updatedFollower = newFollower
        self.account?.followers?.append(updatedFollower.uid)
        updatedFollower.following?.append(uid)
        
        let notification = AppNotification(sender: uid, date: Date(), type: .follow_accepted, notificationData: NotificationData(profile_image_url: account?.profileImageUrl, username: account?.username))
        try notificationClient.saveNotification(for: updatedFollower.uid, notification: notification)
        try await accountClient.removeFromRequested(accountId: updatedFollower.uid)
        return updatedFollower
    }
    
    func updateTrackInfo() {
        account?.appVersion = UIApplication.appVersion
        account?.lastOnline = Date()
        do {
            try account?.save()
        } catch {
            Logger.general.error("Error updating track info: \(error.localizedDescription)")
        }
    }
}
