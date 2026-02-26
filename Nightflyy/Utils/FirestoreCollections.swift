//
//  FirestoreCollections.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/26/24.
//

import Foundation

enum FirestoreCollections {
    
    enum Accounts {
        static let value = "accounts"
        
        static let reviews = "reviews"
        static let notifications = "notifications"
        static let redemptionCode = "redemption_code"
        static let accountType = "account_type"
        static let plusProvider = "plus_provider"
        static let plus_member = "plus_member"
        static let blocked = "blocked"
        static let blockedBy = "blocked_by"
        static let requested = "requested"
        static let token = "token"
        static let followers = "followers"
        static let following = "following"
    }
    
    enum Events {
        static let value = "events"
        
        static let attending = "attending"
        static let invited = "invited"
        static let interested = "interested"
        static let createdBy = "created_by"
        static let endDate = "end_date"
        static let assigned_to = "assigned_to"
        static let l = "l"
        static let comments = "comments"
        static let likes = "likes"
    }
    
    enum Chats {
        static let value = "chats"
        
        static let members = "members"
    }
    
    enum Messages {
        static let value = "messages"
        
        static let date = "date"
    }
    
    enum Usernames {
        static let value = "usernames"
        
        static let usernames = "usernames"
    }
    
    enum Notifications {
        static let value = "notifications"
        
        static let date = "date"
    }
    
    enum NFPRedemptions {
        static let value = "nfp_redemptions"
    }
    
    enum NFPInvites {
        static let value = "nfp_invites"
    }
    
    enum BACodes {
        static let value = "ba_codes"
        
        static let code = "code"
        static let isEnabled = "is_enabled"
        static let redemptions = "redemptions"
    }
    
    enum Reports {
        static let value = "reports"
    }
    
    enum GenericFields {
        static let date = "date"
    }
    
}
