//
//  NFPManager.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/12/25.
//

import SwiftUI
import FirebaseFirestore
import OSLog

@Observable
class NFPManager {
    
    static let shared = NFPManager()
    
    private let accountClient: any AccountClientProtocol
    private let invitesClient: any NFPInvitesClientProtocol
    private let promoCodesClient: any PromoCodesClientProtocol
    private let accountManager: any AccountManaging
    private let iapManager: any IAPManaging
    private let pushNotifications: any PushNotificationsManaging
    private let localNotifications: any LocalNotificationsManaging
    
    private init(
        accountClient: any AccountClientProtocol = AccountClient.shared,
        invitesClient: any NFPInvitesClientProtocol = NFPInvitesClient.shared,
        promoCodesClient: any PromoCodesClientProtocol = PromoCodesClient.shared,
        accountManager: any AccountManaging = AccountManager.shared,
        iapManager: any IAPManaging = IAPManager.shared,
        pushNotifications: any PushNotificationsManaging = PushNotificationsManager.shared,
        localNotifications: any LocalNotificationsManaging = LocalNotificationsManager.shared
    ) {
        self.accountClient = accountClient
        self.invitesClient = invitesClient
        self.promoCodesClient = promoCodesClient
        self.accountManager = accountManager
        self.iapManager = iapManager
        self.pushNotifications = pushNotifications
        self.localNotifications = localNotifications
    }
    
    var isPlusMember: Bool {
        accountManager.account?.hasActiveSubscription ?? false
    }
    
    var hasCredits: Bool {
        accountManager.account?.plusCredits ?? 0 > 0 + (UserDefaultsKeys.bonusCredit.getValue() ?? 0)
    }
    
    var showNFPView: Bool = false
    
    var referralAccount: Account?
    
    var nextCreditDate: Date = {
        let currentDate = Date()
        let calendar = Calendar.current
        let components = DateComponents(timeZone: TimeZone(abbreviation: "EST"), hour: 9, weekday: 2)
        let nextPerkDate = calendar.nextDate(after: currentDate, matching: components, matchingPolicy: .nextTime)
        return nextPerkDate ?? Date()
    }()
    
    var bonusCreditDate: Date = {
        let calendar = Calendar.current
        let bcd = calendar.date(byAdding: .day, value: 7, to: Date())
        return bcd ?? Date()
    }()
    
    var perkReminderDate: Date = {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: Date())
        components.timeZone = TimeZone(abbreviation: "EST")
        components.hour = 18
        components.weekday = 6
        let friday = calendar.date(from: components)
        return friday ?? Date()
    }()
    
    func checkForCredits() {
        if isPlusMember {
            let nextCreditDate = accountManager.account?.nextCreditDate ?? nextCreditDate
            if Date() >= nextCreditDate {
                addCredits()
                addReminderNotification()
            }
            guard let bonusCreditDate = accountManager.account?.bonusCreditDate else { return }
            if Date() > bonusCreditDate {
                UserDefaultsKeys.bonusCredit.setValue(1)
                accountManager.account?.bonusCreditDate = nil
            }
        }
    }
    
    func checkSubscriptionStatus() async {
        do {
            let status = try await iapManager.checkPermissions()
            updatePlusMemberStatus(status: status)
            if status {
                self.checkForCredits()
            }
            else {
                self.cancelPlusMember()
                try await invitesClient.deleteInvites()
            }
            accountManager.saveAccount()
        }
        catch {
            Logger.iap.error("Error checking subscription status: \(error.localizedDescription)")
        }
    }
    
    func makePlusMember(promoCode: String?) async throws {
        if accountManager.account != nil {
            accountManager.account?.plusMember = true
            accountManager.account?.plusCredits = 1
            accountManager.account?.nextCreditDate = nextCreditDate
            if let promoCode = promoCode, promoCode != "" {
                accountManager.account?.bonusCreditDate = bonusCreditDate
                promoCodesClient.addRedemption(code: promoCode)
            }
            if let account = accountManager.account {
                await SendgridManager.createContactInSendgrid(account: account, lists: [.NFPLUS])
            }
            try accountManager.account?.save()
            pushNotifications.subscribeToNotifications(target: .nfplus)
        }
    }
    
    func cancelPlusMember() {
        accountManager.account?.plusMember = false
        accountManager.account?.plusCredits = 0
        accountManager.account?.nextCreditDate = nil
        accountManager.account?.bonusCreditDate = nil
    }
    
    func updatePlusMemberStatus(status: Bool) {
        accountManager.account?.plusMember = status
    }
    
    func addCredits() {
        accountManager.account?.plusCredits = 1
        accountManager.account?.nextCreditDate = nextCreditDate
        do {
            try accountManager.account?.save()
        } catch {
            Logger.iap.error("Error saving credits: \(error.localizedDescription)")
        }
    }
    
    func addReminderNotification() {
        if perkReminderDate > Date() {
            let data = ["type": "nfplus"]
            localNotifications.scheduleLocalNotification(type: .perkReminder, date: perkReminderDate, data: data)
        }
    }
    
    func redeemCredit(code: String) async throws {
        let venue = try await accountClient.fetchVenueByRedemptionCode(code: code)
        
        guard let uid = accountManager.account?.uid,
              let venueID = venue?.id,
              let venueName = venue?.name
        else {
            throw AccountError.invalidCode
        }
        
        let redemption = NFPRedemption(venueID: venueID, venueName: venueName, city: venue?.city, state: venue?.state, date: Date(), clientID: uid)
        try redemption.save()
        if UserDefaultsKeys.bonusCredit.getValue() ?? 0 > 0 {
            UserDefaultsKeys.bonusCredit.removeValue()
        }
        else {
            accountManager.account?.plusCredits = 0
            try accountManager.account?.save()
        }
        localNotifications.removeScheduledNotification(type: .perkReminder)
    }
}
