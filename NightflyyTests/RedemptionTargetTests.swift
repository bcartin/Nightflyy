//
//  RedemptionTargetTests.swift
//  NightflyyTests
//

import Testing
@testable import Nightflyy

struct RedemptionTargetTests {

    private static func venue(_ id: String, _ name: String) -> Account {
        var venue = Account(name: name)
        venue.id = id
        return venue
    }

    private static func event(_ id: String, _ name: String, venueID: String? = nil) -> Event {
        var event = Event(eventName: name, eventVenueId: venueID)
        event.id = id
        return event
    }

    // A correct event code was rejected because an earlier event, or another venue, had the same code.
    @Test func theSelectedEventWinsWhenItsCodeIsShared() throws {
        let target = try RedemptionTarget.matching(
            venues: [Self.venue("other-venue", "Aqua Vitae")],
            events: [Self.event("last-year", "Thanksgiving 2025"), Self.event("finale", "Thanksgiving Finale")],
            acceptedIDs: ["finale", "phoenix"]
        )

        #expect(target == RedemptionTarget(id: "finale", name: "Thanksgiving Finale", type: .event))
    }

    @Test func theHostVenueCodeRedeemsItsEvent() throws {
        let target = try RedemptionTarget.matching(venues: [Self.venue("phoenix", "Phoenix Bar & Lounge")], events: [],
                                                   acceptedIDs: ["finale", "phoenix"])

        #expect(target == RedemptionTarget(id: "phoenix", name: "Phoenix Bar & Lounge", type: .venue))
    }

    @Test func aCodeOnlyOtherPlacesHaveIsForADifferentVenue() {
        #expect(throws: AccountError.codeForDifferentVenue) {
            try RedemptionTarget.matching(venues: [Self.venue("other-venue", "Aqua Vitae")],
                                          events: [Self.event("other-event", "Jazz Night")],
                                          acceptedIDs: ["finale", "phoenix"])
        }
    }

    @Test func aCodeNothingHasIsInvalid() {
        #expect(throws: AccountError.invalidCode) {
            try RedemptionTarget.matching(venues: [], events: [], acceptedIDs: ["finale"])
        }
    }

    @Test func withNoPerkSelectedVenuesComeFirst() throws {
        let target = try RedemptionTarget.matching(venues: [Self.venue("phoenix", "Phoenix Bar & Lounge")],
                                                   events: [Self.event("finale", "Thanksgiving Finale")],
                                                   acceptedIDs: nil)

        #expect(target.id == "phoenix")
    }
}
