//
//  PerkEventsEmptyView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/23/26.
//

import SwiftUI

/// Shown on the perk selection Events tab when there are no events to list.
struct PerkEventsEmptyView: View {

    let state: PerkEventsEmptyState
    let searchText: String

    var body: some View {
        switch state {
        case .loading:
            ProgressView()
                .tint(.white)
        case .noEvents:
            ContentUnavailableView("No Event Perks Right Now", systemImage: "calendar",
                                   description: Text("Check back soon for events with Nightflyy+ perks."))
        case .noSearchResults:
            ContentUnavailableView.search(text: searchText)
        }
    }
}
