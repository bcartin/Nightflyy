//
//  HostingViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 3/3/25.
//

import SwiftUI

@Observable @MainActor
class HostingViewModel {

    var eventsHosting: [EventListItemViewModel] = []
    var headerEvent: EventListItemViewModel?
    var additionalEvents: [EventListItemViewModel] = []

    /// Date line shown above the next hosted event, e.g. "FRI, OCT  27".
    var headerDateText: String {
        "\(headerEvent?.weekday.uppercased() ?? ""), \(headerEvent?.month ?? "")  \(headerEvent?.day ?? "")"
    }

    func setupViewModels() {

        eventsHosting = EventsManager.shared.hostingEvents
            .removingPastEvents()
            .map { EventListItemViewModel(event: $0, autoFetchOwner: true) }
            .sortedByDate()
        headerEvent = eventsHosting.first
        additionalEvents = Array(eventsHosting.dropFirst())
    }

    func fetchEvents(refetch: Bool = false) async {
        await EventsManager.shared.fetchHostingEvents(refetch: refetch)
        setupViewModels()
    }

    func goToGuestList() {
        guard let event = headerEvent?.event else { return }
        let viewModel = EventGuestListViewModel(event: event, selectedSegment: 1)
        Router.shared.navigateTo(.eventGuestList(viewModel))
    }

}
