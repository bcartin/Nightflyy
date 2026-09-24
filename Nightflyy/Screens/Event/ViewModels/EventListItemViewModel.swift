//
//  EventListItemViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/13/24.
//

import Foundation

@Observable @MainActor
class EventListItemViewModel: Hashable {
    
    nonisolated let id: String
    
    nonisolated static func == (lhs: EventListItemViewModel, rhs: EventListItemViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var event: Event
    var eventOwner: Account?
    var isSelected: Bool = false
    
    init(event: Event, autoFetchOwner: Bool = false) {
        self.id = event.uid
        self.event = event
        if autoFetchOwner {
            Task {
                await fetchOwner()
            }
        }
    }
    
    var eventDate: Date {
        return event.endDate ?? .init()
    }
    
    var isPastEvent: Bool {
        return event.endDate ?? Date() < Date()
    }
    
    var weekday: String {
        return String(event.startDate?.stringValue(format: "EEE") ?? .init())
    }
    
    var month: String {
        let dateString = String(event.startDate?.stringValue(format: "MMM dd, yyyy").prefix(6) ?? .init())
        return String(dateString.prefix(3)).uppercased()
    }
    
    var day: String {
        let dateString = String(event.startDate?.stringValue(format: "MMM dd, yyyy").prefix(6) ?? .init())
        return String(dateString.suffix(2))
    }
    
    var numberOFRSVPs: String {
        return "\(event.attending?.count ?? 0)"
    }
    
    func fetchOwner() async {
        guard let ownerId = event.createdBy else { return }
        if !event.isUnclaimed {
            self.eventOwner = await AccountClient.fetchAccount(accountId: ownerId)
        }
    }
    
    func navigateToEvent() {
        Router.shared.navigateToEvent(event: self.event, eventOwner: self.eventOwner)
    }
    
    func markAsSelected() {
        isSelected.toggle()
    }
    
    
}

@MainActor
extension [EventListItemViewModel] {

    func sortedByDate() -> [EventListItemViewModel] {
        return self.sorted { $0.eventDate < $1.eventDate }
    }

}
