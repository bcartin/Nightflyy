//
//  NFPPerk.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/5/26.
//

import Foundation

/// A Nightflyy+ perk offered by a venue or an event, shaped for the perk selection list.
struct NFPPerk: Identifiable {

    let id: String
    let imageUrl: String?
    let title: String
    let perkName: String
    let perkDetails: String?
    /// Where the perk is redeemed: the venue itself, or the venue hosting the event.
    let venueName: String
    /// Venues or events whose redemption code may redeem this perk.
    let acceptedRedemptionIDs: Set<String>
    /// Event perks are redeemed with the door person, before scanning a ticket.
    let isEvent: Bool

    init(venue: Account) {
        id = venue.uid
        imageUrl = venue.profileImageUrl
        title = venue.name ?? ""
        perkName = venue.perkName ?? ""
        perkDetails = venue.perkDetails
        venueName = venue.name ?? ""
        acceptedRedemptionIDs = [venue.uid]
        isEvent = false
    }

    init(event: Event) {
        id = event.uid
        imageUrl = event.eventFlyerUrl
        title = event.eventName ?? ""
        perkName = event.perkName ?? ""
        perkDetails = event.perkDetails
        venueName = event.eventVenue ?? ""
        // The hosting venue's own code works too, since that's the code its staff know.
        acceptedRedemptionIDs = Set([event.uid, event.eventVenueId].compactMap { $0 })
        isEvent = true
    }

    var redemptionSteps: [String] {
        if isEvent {
            [
                "Tap the purple \"Use this Perk\" button",
                "Tell the door person at \(venueName)\n\"I want to use my Nightflyy Plus Perk\"",
                "Hand your phone to the door person to redeem credit",
                "Scan your ticket on Eventbrite, Posh, etc.",
                "Enjoy your \(perkName) and the event!"
            ]
        } else {
            [
                "Tap the purple \"Use this Perk\" button",
                "Tell your server at \(venueName)\n\"I want to use my Nightflyy Plus Perk\"",
                "Hand your phone to the server",
                "Enjoy your \(perkName)"
            ]
        }
    }
}
