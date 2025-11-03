//
//  FirestoreCollections.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/26/24.
//

import Foundation

class FirestoreCollections {
    
    class Accounts {
        static var value = "accounts"
        
        static var reviews = "reviews"
        static var notifications = "notifications"
        static var redemptionCode = "redemption_code"
        static var accountType = "account_type"
        static var plusProvider = "plus_provider"
        static var plus_member = "plus_member"
        static var blocked = "blocked"
        static var blockedBy = "blocked_by"
        static var requested = "requested"
        static var token = "token"
    }
    
    class Events {
        static var value = "events"
        
        static var attending = "attending"
        static var invited = "invited"
        static var interested = "interested"
        static var createdBy = "created_by"
        static var endDate = "end_date"
        static var assigned_to = "assigned_to"
        static var l = "l"
        static var comments = "comments"
        static var likes = "likes"
    }
    
    class Chats {
        static var value = "chats"
        
        static var members = "members"
    }
    
    class Messages {
        static var value = "messages"
        
        static var date = "date"
    }
    
    class Usernames {
        static var value = "usernames"
        
        static var usernames = "usernames"
    }
    
    class Notifications {
        static var value = "notifications"
        
        static var date = "date"
    }
    
    class NFPRedemptions {
        static var value = "nfp_redemptions"
    }
    
    class NFPInvites {
        static var value = "nfp_invites"
    }
    
    class BACodes {
        static var value = "ba_codes"
        
        static var code = "code"
        static var isEnabled = "is_enabled"
        static var redemptions = "redemptions"
    }
    
    class Reports {
        static var value = "reports"
    }
    
    class GenericFields {
        static var date = "date"
    }
    
}
