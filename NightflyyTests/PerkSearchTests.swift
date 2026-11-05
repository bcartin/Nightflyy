//
//  PerkSearchTests.swift
//  NightflyyTests
//

import CoreLocation
import Testing
@testable import Nightflyy

@MainActor
struct PerkSearchTests {

    @Test func venuesMatchByNameOrCity() {
        let venues = [Account(name: "TacoDero", city: "Rochester"), Account(name: "Nashvilles", city: "Buffalo")]

        #expect(NFPRedeemViewModel.filter(venues, by: "").count == 2)
        #expect(NFPRedeemViewModel.filter(venues, by: "taco").map(\.name) == ["TacoDero"])
        #expect(NFPRedeemViewModel.filter(venues, by: "buff").map(\.name) == ["Nashvilles"])
        #expect(NFPRedeemViewModel.filter(venues, by: "zzz").isEmpty)
    }

    @Test func eventsMatchByNameVenueOrAddress() {
        let events = [Event(eventAddress: "1 Main St, Rochester, NY", eventName: "Jazz Night", eventVenue: "Photo City")]

        #expect(NFPRedeemViewModel.filter(events, by: "jazz").count == 1)
        #expect(NFPRedeemViewModel.filter(events, by: "photo").count == 1)
        #expect(NFPRedeemViewModel.filter(events, by: "rochester").count == 1)
        #expect(NFPRedeemViewModel.filter(events, by: "buffalo").isEmpty)
    }

    @Test func eventPerkInstructionsNameTheHostVenue() {
        let perk = NFPPerk(event: Event(eventName: "Jazz Night", eventVenue: "Photo City", perkName: "Free Drink"))

        #expect(perk.title == "Jazz Night")
        #expect(perk.redemptionSteps[1].hasPrefix("Tell your server at Photo City"))
        #expect(perk.redemptionSteps[3] == "Enjoy your Free Drink")
    }

    @Test func venuesSortClosestFirstOnlyWithLocation() {
        let far = Account(name: "Far", latitude: 43.5, longitude: -77.0)
        let near = Account(name: "Near", latitude: 43.16, longitude: -77.61)
        let user = CLLocation(latitude: 43.15, longitude: -77.6)

        #expect(NFPRedeemViewModel.sorted([far, near], near: user).map(\.name) == ["Near", "Far"])
        #expect(NFPRedeemViewModel.sorted([far, near], near: nil).map(\.name) == ["Far", "Near"])
    }

    @Test func perksAcceptOnlyTheirOwnRedemptionCodes() {
        var venue = Account(name: "Aqua Vitae")
        venue.id = "venue1"
        var event = Event(eventName: "Jazz Night", eventVenueId: "venue2")
        event.id = "event1"

        #expect(NFPPerk(venue: venue).acceptedRedemptionIDs == ["venue1"])
        #expect(NFPPerk(event: event).acceptedRedemptionIDs == ["event1", "venue2"])
    }
}
