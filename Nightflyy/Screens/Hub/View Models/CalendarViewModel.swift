//
//  CalendarViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/24/25.
//

import SwiftUI

@Observable
class CalendarViewModel {
    
    var events: [Event] = .init()
    var selectedDate: Date = .now
    
    init() {
        self.events.append(contentsOf: EventsManager.shared.hostingEvents)
        self.events.append(contentsOf: EventsManager.shared.attendingEvents)
    }
    
    var selectedDayEvents: [EventListItemViewModel] {
        return events.filter({$0.startDate!.isSameDay(as: selectedDate)}).map{EventListItemViewModel(event: $0, autoFetchOwner: true)}.sortedByDate()
    }
    
    var hasEventsForSelectedDay: Bool {
        return !selectedDayEvents.isEmpty
    }
    
    
}
