//
//  Account.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/7/24.
//

import Foundation
import FirebaseFirestore

struct Account: Identifiable, Codable, Savable {
    static var collection: String = FirestoreCollections.Accounts.value
    
    @DocumentID var id = UUID().uuidString
    var accountIsPrivate: Bool?
    var accountType: AccountType?
    var address: String?
    var appVersion: String?
    var attending: [String]?
    var badgeCount: Int?
    var bio: String?
    var blocked: [String]?
    var blockedBy: [String]?
    @ExplicitNull var bonusCreditDate: Date? = nil
    var businessEmail: String?
    var chats: [String]?
    var city: String?
    var clientele: [String]?
    var dob: String?
    var email: String?
    var followers: [String]?
    var following: [String]?
    var gender: Int?
    var geohash: String?
    var hidden: [String]?
    var invited: [String]?
    var interested: [String]?
    var isAdmin: Bool? = false
    var isTester: Bool? = false
    var lastOnline: Date?
    var location: GeoPoint?
    var messageCount: Int?
    var music: [String]?
    var name: String?
    var nextCreditDate: Date?
    var notificationSettings: NotificationSettings?
    var numberOfReviews: Int?
    var perkDetails: String?
    var perkName: String?
    var phoneNumber: String?
    var photoFileName: String?
    var plusCredits: Int?
    var plusMember: Bool?
    var plusProvider: Bool?
    var profileImageUrl: String?
    var rating: Float?
    var redemptionCode: String?
    var requested: [String]?
    var reviews: [Review]?
    var state: String?
    var token: String?
    var username: String?
    var venues:[String]?
    var venueType: String?
    var website: String?

    var uid: String {
        return self.id!
    }
    
    func getFollowingStatus(uid: String) -> FollowingStatus {
        if let following = self.following, following.contains(uid) {
            return .following
        }
        if let requested = self.requested, requested.contains(uid) {
            return .requested
        }
        return .notFollowing
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case accountIsPrivate = "account_is_private"
        case accountType = "account_type"
        case address
        case appVersion = "app_version"
        case attending
        case badgeCount = "badge_count"
        case bio
        case blocked
        case blockedBy = "blocked_by"
        case bonusCreditDate = "bonus_credit_date"
        case businessEmail = "business_email"
        case chats
        case city
        case clientele
        case dob
        case email
        case followers
        case following
        case gender
        case geohash = "g"
        case hidden
        case invited
        case interested
        case isAdmin = "is_admin"
        case isTester = "is_tester"
        case lastOnline = "last_online"
        case location = "l"
        case messageCount = "messages_count"
        case music
        case name
        case nextCreditDate = "next_credit_date"
        case notificationSettings = "notification_settings"
        case numberOfReviews = "number_of_reviews"
        case perkDetails = "perk_details"
        case perkName = "perk_name"
        case phoneNumber = "phone_number"
        case photoFileName = "photo_file_name"
        case plusCredits = "plus_credits"
        case plusMember = "plus_member"
        case plusProvider = "plus_provider"
        case profileImageUrl = "profile_image_url"
        case rating
        case redemptionCode = "redemption_code"
        case requested
        case reviews
        case state
        case token
        case username
        case venues
        case venueType = "venue_type"
        case website
    }
}

extension Account {
    
    func save() throws {
        do {
            try FirebaseManager.shared.db.collection(Account.collection).document(id!).setData(from: self, merge: true)
            firebaseCache[uid] = .account(self)
        }
        catch {
            throw error
        }
    }
    
    func updateCache() {
        firebaseCache[uid] = .account(self)
    }
}

extension Account: Equatable {
    static func == (lhs: Account, rhs: Account) -> Bool {
        lhs.uid == rhs.uid
    }
    
    
}
