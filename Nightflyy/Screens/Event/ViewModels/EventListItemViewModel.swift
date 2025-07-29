//
//  EventListItemViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/13/24.
//

import Foundation

@Observable
class EventListItemViewModel: NSObject {
    
    var event: Event
    var eventOwner: Account?
    var isSelected: Bool = false
    
    init(event: Event, autoFetchOwner: Bool = false) {
        self.event = event
        super.init()
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
            let fetchOwnerTask = Task { @MainActor () -> Account? in
                let result = await AccountClient.fetchAccount(uid: ownerId)
                switch result {
                    
                case .success(let account):
                    return account
                case .failure(_):
                    return nil
                }
            }
            
            let result = await fetchOwnerTask.result
            self.eventOwner = result.get()
        }
    }
    
    func navigateToEvent() {
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
//            guard let self = self else { return }
            let viewModel = EventViewModel(event: self.event, eventOwner: self.eventOwner)
            Router.shared.navigateTo(.Event(viewModel))
//        })
    }
    
    func markAsSelected() {
        isSelected.toggle()
    }
    
    
}

extension [EventListItemViewModel] {
    
    func sortedByDate() -> [EventListItemViewModel] {
        return self.sorted { $0.eventDate < $1.eventDate }
    }
    
}
