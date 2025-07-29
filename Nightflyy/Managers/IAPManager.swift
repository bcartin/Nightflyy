//
//  IAPManager.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/27/25.
//

import SwiftUI
import OSLog
import Qonversion

@Observable
class IAPManager {
    
    static let shared = IAPManager()
    
    private init() { }
    
    func configure(with key: String) -> Bool {
        let configuration = Qonversion.Configuration(projectKey: key, launchMode: .subscriptionManagement)
        Qonversion.initWithConfig(configuration)
        return true
    }
    
    func checkPermissions() async throws -> Bool {
        let entitlements = try await Qonversion.shared().checkEntitlements()
        if let subscription: Qonversion.Entitlement = entitlements["Basic"], subscription.isActive {
            return true
        }
        else {
            print("Subscription is inactive")
            return false
        }
        
    }
    
    func purchase(venue: Account?) async throws -> Bool {
        let purchaseResult = try await Qonversion.shared().purchase("basic_subscription")
//        let entitlements = purchaseResult.0
        let success = purchaseResult.1
        if success {
            if let uid = AccountManager.shared.account?.uid {
                Qonversion.shared().setUserProperty(.userID, value: uid)
            }
            if let venueId = venue?.uid  {
                Qonversion.shared().setUserProperty(.custom, value: venueId)
            }
        }
        return success
    }
        
    func restorePurchases() async throws {
        _ = try await Qonversion.shared().restore()
    }
}
