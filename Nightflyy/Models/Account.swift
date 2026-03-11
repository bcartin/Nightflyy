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
    
    // MARK: - Identity
    var accountType: AccountType?
    var accountIsPrivate: Bool?
    var name: String?
    var username: String?
    var email: String?
    var dob: String?
    var gender: Int?
    var bio: String?
    var phoneNumber: String?
    var profileImageUrl: String?
    var photoFileName: String?
    
    // MARK: - Venue Profile
    var address: String?
    var businessEmail: String?
    var clientele: [String]?
    var music: [String]?
    var numberOfReviews: Int?
    var perkDetails: String?
    var perkName: String?
    var rating: Float?
    var redemptionCode: String?
    var reviews: [Review]?
    var venues: [String]?
    var venueType: String?
    var website: String?
    
    // MARK: - Plus Subscription
    @ExplicitNull var bonusCreditDate: Date? = nil
    var nextCreditDate: Date?
    var plusCredits: Int?
    var plusMember: Bool?
    var plusProvider: Bool?
    
    // MARK: - Social
    var attending: [String]?
    var blocked: [String]?
    var blockedBy: [String]?
    var chats: [String]?
    var followers: [String]?
    var following: [String]?
    var hidden: [String]?
    var interested: [String]?
    var invited: [String]?
    var requested: [String]?
    
    // MARK: - Location
    var city: String?
    var state: String?
    var geohash: String?
    var location: GeoPoint?
    
    // MARK: - App Metadata
    var appVersion: String?
    var badgeCount: Int?
    var isAdmin: Bool? = false
    var isTester: Bool? = false
    var lastOnline: Date?
    var messageCount: Int?
    var notificationSettings: NotificationSettings?
    var token: String?
    
    // MARK: - Computed Properties

    var uid: String {
        return self.id ?? ""
    }
    
    // MARK: - Codable
    
    
    enum CodingKeys: String, CodingKey {
        case id
        
        // Identity
        case accountType = "account_type"
        case accountIsPrivate = "account_is_private"
        case name
        case username
        case email
        case dob
        case gender
        case bio
        case phoneNumber = "phone_number"
        case profileImageUrl = "profile_image_url"
        case photoFileName = "photo_file_name"
        
        // Venue Profile
        case address
        case businessEmail = "business_email"
        case clientele
        case music
        case numberOfReviews = "number_of_reviews"
        case perkDetails = "perk_details"
        case perkName = "perk_name"
        case rating
        case redemptionCode = "redemption_code"
        case reviews
        case venues
        case venueType = "venue_type"
        case website
        
        // Plus Subscription
        case bonusCreditDate = "bonus_credit_date"
        case nextCreditDate = "next_credit_date"
        case plusCredits = "plus_credits"
        case plusMember = "plus_member"
        case plusProvider = "plus_provider"
        
        // Social
        case attending
        case blocked
        case blockedBy = "blocked_by"
        case chats
        case followers
        case following
        case hidden
        case interested
        case invited
        case requested
        
        // Location
        case city
        case state
        case geohash = "g"
        case location = "l"
        
        // App Metadata
        case appVersion = "app_version"
        case badgeCount = "badge_count"
        case isAdmin = "is_admin"
        case isTester = "is_tester"
        case lastOnline = "last_online"
        case messageCount = "messages_count"
        case notificationSettings = "notification_settings"
        case token
    }
}

extension Account {
    
    func save() throws {
        try FirebaseManager.shared.db.collection(Account.collection).document(id!).setData(from: self, merge: true)
        firebaseCache[uid] = .account(self)
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
