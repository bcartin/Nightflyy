//
//  NFPRedeemViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/12/25.
//

import Foundation
import CoreLocation
import SwiftUI

enum RedeemView {

    case hasCredits
    case redeemButton
    case noCredits
    case codeScreen
    case redeemSuccess
    case venues
    case help
}

@Observable @MainActor
class NFPRedeemViewModel {

    var displayView: RedeemView = .hasCredits
    var venueCode: String = ""
    var error: Error?
    var nfpVenues: [Account] = .init()
    var nfpEvents: [Event] = .init()
    var perkSearchText: String = "" {
        didSet { selectedPerkId = nil }
    }
    var selectedPerkSegment: Int = 1
    var selectedPerkId: String?
    /// Bumped after a failed redemption so the swipe control resets for another try.
    var redeemAttempts: Int = 0
    var isSharingPerk = false
    let perkSegments = [SegmentedViewOption(id: 1, title: "Venues"), SegmentedViewOption(id: 2, title: "Events")]
    var seeVenuesButtonIsVisible = true

    var nextCreditDate = NFPManager.shared.nextCreditDate

    var day: Int = 0
    var hour: Int = 0
    var minute: Int = 0
    var second: Int = 0

    var helpOptions: [NFPHelpOption] = [.faq, .support, .report, .issue, .feedback, .locations]

    init() {
        displayView = mainDisplayView
        updateTimer()
    }

    func changeView(to view: RedeemView) {
        withAnimation {
            displayView = view
        }
    }

    var mainDisplayView: RedeemView {
        return NFPManager.shared.hasCredits ? .hasCredits : .noCredits
    }

    func redeemCredit() {
        Task {
            do {
                try await NFPManager.shared.redeemCredit(code: venueCode, acceptedIDs: selectedPerk?.acceptedRedemptionIDs)
                changeView(to: .redeemSuccess)
            } catch {
                self.error = error
                redeemAttempts += 1
            }
        }
    }

    func updateTimer() {
        let calendar = Calendar(identifier: .gregorian)
        let timeValue = calendar.dateComponents([.day, .hour, .minute, .second], from: Date.now, to: nextCreditDate)

        self.day = timeValue.day ?? 0
        self.hour = timeValue.hour ?? 0
        self.minute = timeValue.minute ?? 0
        self.second = timeValue.second ?? 0
    }

    func fetchNFPVenues() async {
        let venues = await AccountClient.fetchNightflyyPlusProviders().filter { $0.isVenue }
        nfpVenues = Self.sorted(venues, near: LocationManager.shared.currentLocation)
    }

    /// Closest venues first, or the original order when the user hasn't shared their location.
    static func sorted(_ venues: [Account], near location: CLLocation?) -> [Account] {
        guard let location else { return venues }
        return venues.sorted { $0.distance(to: location) < $1.distance(to: location) }
    }

    func fetchNFPEvents() async {
        nfpEvents = await EventClient.fetchNightflyyPlusEvents()
    }

    // MARK: - Perk Selection

    /// Perks for the selected tab, narrowed by the search text.
    var displayedPerks: [NFPPerk] {
        if selectedPerkSegment == 1 {
            Self.filter(nfpVenues, by: perkSearchText).map(NFPPerk.init(venue:))
        } else {
            Self.filter(nfpEvents, by: perkSearchText).map(NFPPerk.init(event:))
        }
    }

    var perkSearchPrompt: String {
        guard selectedPerkId != nil else { return "Search for venues or events by name or city" }
        return selectedPerkSegment == 1 ? "Search for venues by name or city" : "Search for events by name or city"
    }

    /// Venues whose name or city match the search text.
    static func filter(_ venues: [Account], by searchText: String) -> [Account] {
        guard !searchText.isEmpty else { return venues }
        return venues.filter { matches([$0.name, $0.city], searchText) }
    }

    /// Events whose name, venue or address (which holds the city) match the search text.
    static func filter(_ events: [Event], by searchText: String) -> [Event] {
        guard !searchText.isEmpty else { return events }
        return events.filter { matches([$0.eventName, $0.eventVenue, $0.eventAddress], searchText) }
    }

    private static func matches(_ fields: [String?], _ searchText: String) -> Bool {
        fields.contains { $0?.localizedStandardContains(searchText) ?? false }
    }

    var selectedPerk: NFPPerk? {
        displayedPerks.first { $0.id == selectedPerkId }
    }

    /// Expands a perk to show its redemption instructions, or collapses it when tapped again.
    func perkTapped(_ perk: NFPPerk) {
        withAnimation(.smooth) {
            selectedPerkId = selectedPerkId == perk.id ? nil : perk.id
        }
    }

    /// Goes to the show-your-phone screen, or straight to the staff code screen once the member has hidden it.
    func usePerk() {
        seeVenuesButtonIsVisible = false
        let hidesShowPhoneScreen: Bool = UserDefaultsKeys.hideShowPhoneScreen.getValue() ?? false
        changeView(to: hidesShowPhoneScreen ? .codeScreen : .redeemButton)
    }

    func continueToCode() {
        changeView(to: .codeScreen)
    }

    /// Never Show Again: remembers the choice and moves on to the staff code screen.
    func hideShowPhoneScreen() {
        UserDefaultsKeys.hideShowPhoneScreen.setValue(true)
        continueToCode()
    }

    func cancelRedemption() {
        venueCode = ""
        seeVenuesButtonIsVisible = true
        changeView(to: mainDisplayView)
    }

    func navigateToProfile(account: Account) {
        Router.shared.navigateToProfile(account: account)
    }

}
