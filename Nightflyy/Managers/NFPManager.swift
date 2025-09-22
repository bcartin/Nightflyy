//
//  NFPManager.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/12/25.
//

import SwiftUI
import FirebaseFirestore

@Observable
class NFPManager {
    
    static let shared = NFPManager()
    
    private init() { }
    
    var isPlusMember: Bool {
        AccountManager.shared.account?.plusMember ?? false 
    }
    
    var hasCredits: Bool {
        AccountManager.shared.account?.plusCredits ?? 0 > 0 + (UserDefaultsKeys.bonusCredit.getValue() ?? 0)
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
            let nextCreditDate = AccountManager.shared.account?.nextCreditDate ?? nextCreditDate
            if Date() >= nextCreditDate {
                addCredits()
                addReminderNotification()
            }
            guard let bonusCreditDate = AccountManager.shared.account?.bonusCreditDate else { return }
            if Date() > bonusCreditDate {
                UserDefaultsKeys.bonusCredit.setValue(1)
                AccountManager.shared.account?.bonusCreditDate = nil
            }
        }
    }
    
    func checkSubscriptionStatus() async {
        do {
            let status = try await IAPManager.shared.checkPermissions()
            updatePlusMemberStatus(status: status)
            if status {
                self.checkForCredits()
            }
            else {
                self.cancelPlusMember()
                try await NFPInvitesClient.deleteInvites()
            }
            AccountManager.shared.saveAccount()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func makePlusMember(promoCode: String?) async throws {
        if AccountManager.shared.account != nil {
            AccountManager.shared.account?.plusMember = true
            AccountManager.shared.account?.plusCredits = 1
            AccountManager.shared.account?.nextCreditDate = nextCreditDate
            if let promoCode = promoCode {
                AccountManager.shared.account?.bonusCreditDate = bonusCreditDate
                PromoCodesClient.addRedemption(code: promoCode)
            }
            if let account = AccountManager.shared.account {
                await SendgridManager.createContactInSendgrid(account: account, lists: [.NFPLUS])
            }
            do {
                try AccountManager.shared.account?.save()
                await PushNotificationsManager.shared.subscribeToNotifications(target: .nfplus)
            }
            catch {
                throw error
            }
        }
    }
    
    func cancelPlusMember() {
        AccountManager.shared.account?.plusMember = false
        AccountManager.shared.account?.plusCredits = 0
        AccountManager.shared.account?.nextCreditDate = nil
        AccountManager.shared.account?.bonusCreditDate = nil
    }
    
    func updatePlusMemberStatus(status: Bool) {
        AccountManager.shared.account?.plusMember = status
    }
    
    func addCredits() {
        AccountManager.shared.account?.plusCredits = 1
        AccountManager.shared.account?.nextCreditDate = nextCreditDate
        try? AccountManager.shared.account?.save()
    }
    
    func addReminderNotification() {
        if perkReminderDate > Date() {
            PushNotificationsManager.shared.perkReminderNotification(for: perkReminderDate)
        }
    }
    
    func redeemCredit(code: String) async -> Result<Bool, Error> {
        do {
            let venue = try await AccountClient.fetchVenueByRedemptionCode(code: code)
            
            guard let uid = AccountManager.shared.account?.uid,
                  let venueID = venue?.id,
                  let venueName = venue?.name
            else {
                return .failure(AccountError.invalidCode)
            }
            
            let redemption = NFPRedemption(venueID: venueID, venueName: venueName, city: venue?.city, state: venue?.state, date: Date(), clientID: uid)
            try redemption.save()
            if UserDefaultsKeys.bonusCredit.getValue() ?? 0 > 0 {
                UserDefaultsKeys.bonusCredit.removeValue()
            }
            else {
                AccountManager.shared.account?.plusCredits = 0
                try AccountManager.shared.account?.save()
            }
            await PushNotificationsManager.shared.deleteDateNotificationRequest(identifiers: ["perk_reminder_notification"])
            return .success(true)
        }
        catch {
            return .failure(AccountError.invalidCode)
        }
    }
}
