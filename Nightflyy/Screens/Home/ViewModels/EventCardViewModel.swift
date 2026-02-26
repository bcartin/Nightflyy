//
//  EventCardViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/12/24.
//

import Foundation
import SwiftUI

@Observable @MainActor
class EventCardViewModel {
    
    var event: Event
    var eventOwner: Account?
    var attendanceStatus: AttendanceStatus = .notAttending
    var presentInviteScreen: Bool = false
    var error: Error?

    init(event: Event) {
        self.event = event
        self.setAttendanceStatus()
        Task {
            await fetchOwner()
        }
    }
    
    var eventDateString: String {
        return event.startDate?.stringValue(format: "EEE, MMM dd") ?? ""
    }
    
    var ownerName: String {
        return eventOwner?.username ?? "Unclaimed"
    }
    
    var eventLocation: String {
        if let venue = event.eventVenue {
            return venue
        }
        else {
            return ""
        }
    }
    
    var attendingButtonProperties: (icon: String, title: String, color: Color) {
        let icon = attendanceStatus == .attending ? "ic_going" : "ic_interested"
        let title = attendanceStatus == .attending ? "Going" : "Interested"
        let color = attendanceStatus == .notAttending ? Color.white : Color.mainPurple
        
        return (icon, title, color)
    }
    
    var shareLink: URL {
        URL(string: "https://app.nightflyy.com/?type=event&id=\(event.uid)")!
    }
    
    func fetchOwner() async {
        guard let ownerId = event.createdBy else { return }
        if !event.isUnclaimed {
            self.eventOwner = await AccountClient.fetchAccount(accountId: ownerId)
        }
    }
    
    func setAttendanceStatus() {
        guard let uid = AccountManager.shared.account?.uid else { return }
        self.attendanceStatus = event.getAttendanceStatus(uid: uid)
    }
    
    func navigateToProfile() {
        if let account = eventOwner {
            let viewModel = ProfileViewModel(account: account)
            Router.shared.navigateTo(.Profile(viewModel))
        }
    }
    
    func navigateToEventDetails() {
        let viewModel = EventViewModel(event: event, eventOwner: eventOwner)
        Router.shared.navigateTo(.Event(viewModel))
    }
    
    func navigateToGuestList() {
        let viewModel = EventGuestListViewModel(event: event, selectedSegment: 1)
        Router.shared.navigateTo(.EventGuestList(viewModel))
    }
    
    func navigateToSendAsMessage() {
        let viewModel = SendObjectAsMessageViewModel(event: self.event)
        Router.shared.navigateTo(.SendObjectAsMessage(viewModel))
    }
    
    func markAsAttenging() {
        Task {
            do {
                var eventCopy = event
                try await EventAttendanceManager.shared.markAsAttending(event: &eventCopy)
                event = eventCopy
                EventsManager.shared.updateEventLists(with: event)
                setAttendanceStatus()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }

    func markAsInterested() {
        Task {
            do {
                var eventCopy = event
                try await EventAttendanceManager.shared.markAsInterested(event: &eventCopy)
                event = eventCopy
                EventsManager.shared.updateEventLists(with: event)
                setAttendanceStatus()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }

    func markAsNotAttending() {
        Task {
            do {
                var eventCopy = event
                try await EventAttendanceManager.shared.markAsNotAttending(event: &eventCopy)
                event = eventCopy
                EventsManager.shared.updateEventLists(with: event)
                setAttendanceStatus()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func handleInviteFriendsTapped() {
        if event.guestsCanInvite ?? true {
            presentInviteScreen = true
        }
        else {
            error = EventError.cannotInvite
        }
    }
    
}
