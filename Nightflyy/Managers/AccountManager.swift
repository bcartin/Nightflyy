//
//  AccountManager.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/7/24.
//

import SwiftUI
import OSLog

@Observable
class AccountManager {
    
    static let shared = AccountManager()
    
    var account: Account?
    
    private init() { }
    
    var isPersonalAccount: Bool {
        self.account?.accountType == .personal
    }
    
    var isPlusMember: Bool {
       account?.plusMember ?? false 
    }
    
    var isPlusProvider: Bool {
        account?.plusProvider ?? false
    }
    
    var isAdmin: Bool {
        self.account?.isAdmin ?? false
    }
    
    func saveAccount() {
        do {
            try account?.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchAccount(uid: String) async {
            let result = await AccountClient.fetchAccount(uid: uid) 
            switch result {
                
            case .success(let account):
                self.account = account
                Logger.network.info("User account successfully loaded")
            case .failure(let error):
                Logger.network.error("Error fetching user account. \(error.localizedDescription)")
            }
    }
    
    func followAccount(accountToFollow: inout Account) throws {
        
        guard let uid = self.account?.uid else { return }
        
        // Add account into my following
        var following = self.account?.following ?? []
        following.append(accountToFollow.uid)
        self.account?.following = following
        try self.account?.save()
        
        //Add my account to users followers
        var followers = accountToFollow.followers ?? []
        followers.append(uid)
        accountToFollow.followers = followers
        try accountToFollow.save()
        
        let notification = AppNotification(sender: uid, date: Date(), type: .follow_start, notificationData: NotificationData(profile_image_url: account?.profileImageUrl, username: account?.username))
        try AppNotificationClient.saveNotification(for: accountToFollow.uid, notification: notification)
    }
    
    func unfollowAccount(accountToFollow: inout Account) throws {
        if let index1 = account?.following?.firstIndex(of: accountToFollow.uid) {
            self.account?.following?.remove(at: index1)
            try self.account?.save()
        }
        if let index2 = accountToFollow.followers?.firstIndex(of: account?.uid ?? "") {
            accountToFollow.followers?.remove(at: index2)
            try accountToFollow.save()
        }
    }
    
    func requestToFollowAccount(accountId: String) throws {
        var requested = self.account?.requested ?? []
        requested.append(accountId)
        self.account?.requested = requested
        try self.account?.save()
        
        guard let uid = self.account?.uid else { return }
        let notification = AppNotification(sender: uid, date: Date(), type: .follow_request, notificationData: NotificationData(profile_image_url: account?.profileImageUrl, username: account?.username))
        try AppNotificationClient.saveNotification(for: accountId, notification: notification)
    }
    
    func acceptFollowRequest(from newFollower: inout Account) async throws {
        guard let uid = self.account?.uid else { return }
        self.account?.followers?.append(newFollower.uid)
        try self.account?.save()
        newFollower.following?.append(uid)
        try newFollower.save()
        
        let notification = AppNotification(sender: uid, date: Date(), type: .follow_accepted, notificationData: NotificationData(profile_image_url: account?.profileImageUrl, username: account?.username))
        try AppNotificationClient.saveNotification(for: newFollower.uid, notification: notification)
        try await AccountClient.removeFromRequested(accountId: newFollower.uid)
    }
    
    func updateTrackInfo() {
        account?.appVersion = UIApplication.appVersion
        account?.lastOnline = Date()
        try? account?.save()
    }
}
