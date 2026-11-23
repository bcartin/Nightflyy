//
//  PerkEventsEmptyState.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/23/26.
//

/// Why the perk selection Events tab has nothing to list.
enum PerkEventsEmptyState: Equatable {
    case loading
    /// No upcoming events have a Nightflyy+ perk.
    case noEvents
    /// There are event perks, but the search hides them all.
    case noSearchResults
}
