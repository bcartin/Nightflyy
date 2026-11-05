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

    init(venue: Account) {
        id = venue.uid
        imageUrl = venue.profileImageUrl
        title = venue.name ?? ""
        perkName = venue.perkName ?? ""
        perkDetails = venue.perkDetails
        venueName = venue.name ?? ""
    }

    init(event: Event) {
        id = event.uid
        imageUrl = event.eventFlyerUrl
        title = event.eventName ?? ""
        perkName = event.perkName ?? ""
        perkDetails = event.perkDetails
        venueName = event.eventVenue ?? ""
    }

    var redemptionSteps: [String] {
        [
            "Tap the purple \"Use this Perk\" button",
            "Tell your server at \(venueName)\n\"I want to use my Nightflyy Plus Perk\"",
            "Hand your phone to the server",
            "Enjoy your \(perkName)"
        ]
    }
}
