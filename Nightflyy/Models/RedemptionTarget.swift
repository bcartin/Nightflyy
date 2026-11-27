//
//  RedemptionTarget.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/27/26.
//

import Foundation

/// The venue or event a member's redemption code redeems.
struct RedemptionTarget: Equatable {

    let id: String
    let name: String
    let type: RedemptionType

    /// Picks what the code redeems from every venue and event that has it.
    ///
    /// Codes aren't unique: a venue may reuse its code for each of its events, or two venues may share one.
    /// So the match for the selected perk (`acceptedIDs`) wins, wherever it is in the list. With no perk
    /// selected, venues come before events.
    /// - Throws: `AccountError.invalidCode` if nothing has the code, or `.codeForDifferentVenue` if
    ///   only venues and events other than the selected perk's have it.
    static func matching(venues: [Account], events: [Event], acceptedIDs: Set<String>?) throws -> RedemptionTarget {
        let venueTargets = venues.compactMap { venue in
            venue.name.map { RedemptionTarget(id: venue.uid, name: $0, type: .venue) }
        }
        let eventTargets = events.compactMap { event in
            event.eventName.map { RedemptionTarget(id: event.uid, name: $0, type: .event) }
        }
        let targets = venueTargets + eventTargets
        guard let first = targets.first else { throw AccountError.invalidCode }
        guard let acceptedIDs else { return first }
        guard let accepted = targets.first(where: { acceptedIDs.contains($0.id) }) else {
            throw AccountError.codeForDifferentVenue
        }
        return accepted
    }
}
