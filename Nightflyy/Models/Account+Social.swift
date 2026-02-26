//
//  Account+Social.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 2/25/26.
//

import Foundation

// MARK: - Social Convenience

extension Account {
    
    func getFollowingStatus(uid: String) -> FollowingStatus {
        if let following = self.following, following.contains(uid) {
            return .following
        }
        if let requested = self.requested, requested.contains(uid) {
            return .requested
        }
        return .notFollowing
    }
    
    func isFollowing(_ uid: String) -> Bool {
        following?.contains(uid) ?? false
    }
    
    func isBlocked(_ uid: String) -> Bool {
        blocked?.contains(uid) ?? false
    }
    
    var followerCount: Int {
        followers?.count ?? 0
    }
    
    var followingCount: Int {
        following?.count ?? 0
    }
    
}
