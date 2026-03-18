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
class IAPManager: IAPManaging {
    
    static let shared = IAPManager()
    
    private let accountManager: any AccountManaging
    
    private init(
        accountManager: any AccountManaging = AccountManager.shared
    ) {
        self.accountManager = accountManager
    }
    
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
            Logger.iap.info("Subscription is inactive")
            return false
        }
        
    }
    
    func purchase(venue: Account?) async throws -> Bool {
        let products = try await Qonversion.shared().products()
        guard let main = products["basic_subscription_2026"] else {
            throw IAPError.productNotFound
        }
        let purchaseResult = await Qonversion.shared().purchase(main)
        if purchaseResult.isSuccessful {
            if let account = AccountManager.shared.account {
                Qonversion.shared().setUserProperty(.userID, value: account.uid)
                Qonversion.shared().setUserProperty(.email, value: account.email ?? "N/A")
                Qonversion.shared().setUserProperty(.name, value: venue?.name ?? "N/A")
            }
            if let venue = venue {
                Qonversion.shared().setCustomUserProperty("referralAccountId", value: venue.uid)
                Qonversion.shared().setCustomUserProperty("referralAccountName", value: venue.name ?? "N?A")
            }
            return true
        }
        return false
    }
        
    func restorePurchases() async throws {
        _ = try await Qonversion.shared().restore()
    }
}
