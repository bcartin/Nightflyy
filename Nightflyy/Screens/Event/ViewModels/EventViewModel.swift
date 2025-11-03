//
//  EventViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/14/24.
//

import Foundation
import SwiftUI

@Observable
class EventViewModel: NSObject {
    
    var event: Event
    var eventOwner: Account?
    var presentInterestedDialog: Bool = false
    var presentOptionsDialog: Bool = false
    var presentShareDialog: Bool = false
    var presentCancelAlert: Bool = false
    var presentInviteScreen: Bool = false
    var presentSendAsMessageScreen: Bool = false
    var preseentCommentsScreen: Bool = false
    var error: Error?
    var attendanceStatus: AttendanceStatus = .notAttending
//    var numberOfComments: Int = 0
    var comments: [Comment] = .init()
    var commentsViewModels: [EventCommentViewModel] = .init()
    var commentText: String = ""
    
    init(event: Event, eventOwner: Account? = nil) {
        self.event = event
        self.eventOwner = eventOwner
        super.init()
        
        Task {
            await fetchEventOwner()
            self.setAttendanceStatus()
        }
        
        print(event.uid)
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
    
    var numberOfAttendees: String {
        return String(describing: event.attending?.count ?? 0)
    }
    
    var isOwner: Bool {
        return AccountManager.shared.account?.uid == eventOwner?.uid
    }
    
    var eventOwnerName: String {
        return eventOwner?.username ?? "Unclaimed"
    }
    
    var startTimeString: String {
        return event.startTime?.lowercased().replacingOccurrences(of: "\\s*", with: "$1", options: [.regularExpression]) ?? ""
    }
    
    var endTimeString: String {
        return event.endTime?.lowercased().replacingOccurrences(of: "\\s*", with: "$1", options: [.regularExpression]) ?? ""
    }
    
    var hasLink: Bool {
        if let url = event.ticketingUrl, !url.isEmpty {
            return true
        }
        else {
            return false
        }
    }
    
    var shouldShowOptionsButton: Bool {
        return AccountManager.shared.account?.uid == eventOwner?.uid || AccountManager.shared.isAdmin
    }
    
    var eventPrice: String {
        if event.eventIsFree ?? false {
            return "Free"
        }
        else {
            let minPrice = event.minPrice ?? 0
            let maxPrice = event.maxPrice ?? 0
            return minPrice == maxPrice ? "\(minPrice)" : "$\(minPrice) - $\(maxPrice)"
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
    
    var showClaimView: Bool {
        return event.assignedTo == AccountManager.shared.account?.uid && (event.createdBy == nil || event.createdBy == "unclaimed") 
    }
    
    var venueHasProfile: Bool {
        event.eventVenueId != nil
    }
    
    func setAttendanceStatus() {
        guard let uid = AccountManager.shared.account?.uid else { return }
        self.attendanceStatus = event.getAttendanceStatus(uid: uid)
    }
    
    func navigateToOwnerProfile() {
        guard let account = eventOwner else { return }
        let viewModel = ProfileViewModel(account: account)
        Router.shared.navigateTo(.Profile(viewModel))
    }
    
    func markAsAttenging() {
        Task {
            do {
                try await EventAttendanceManager.shared.markAsAttenging(event: &event)
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
                try await EventAttendanceManager.shared.markAsInterested(event: &event)
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
                try await EventAttendanceManager.shared.markAsNotAttending(event: &event)
                EventsManager.shared.updateEventLists(with: event)
                setAttendanceStatus()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func openMapsWithAddress() {
        guard let address = event.eventAddress else { return }
        Task {
            await MapsManager.openMapsWithAddress(address)
        }
    }
    
    func goToEditEvent() {
        presentOptionsDialog = false
        let viewModel = CreateEventViewModel(event: event)
        viewModel.updatedEvent = { [weak self] event in
            self?.event = event
            General.showSavedMessage()
        }
        Router.shared.navigateTo(.CreateEvent(viewModel))
    }
    
    func deleteEvent() {
        Task {
            do {
                try await EventClient.deleteEvent(eventId: event.uid)
                presentCancelAlert = false
                General.showSuccessMessage(message: "Event Deleted", imageName: "checkmark.circle.fill")
            }
            catch {
                presentCancelAlert = false
                self.error = error
            }
        }
    }
    
    func claimEvent() {
        Task {
            do {
                guard let uid = AccountManager.shared.account?.uid else {return}
                try await EventClient.setEventOwner(eventId: event.uid, uid: uid)
                event.createdBy = uid
                firebaseCache.removeObject(forKey: event.uid as NSString)
                eventOwner = AccountManager.shared.account
                EventsManager.shared.updateEventLists(with: event)
                General.showSuccessMessage(message: "Event Claimed")
            }
            catch {
                presentCancelAlert = false
                self.error = error
            }
        }
    }
    
    func declineEvent() {
        Task {
            do {
                try await EventClient.declineClaim(eventId: event.uid)
                event.assignedTo = nil
                event.updateCache()
                EventsManager.shared.updateEventLists(with: event)
            }
            catch {
                presentCancelAlert = false
                self.error = error
            }
        }
    }
    
    func handleInviteFriendsTapped() {
        if event.guestsCanInvite ?? true {
            presentShareDialog = false
            presentInviteScreen = true
        }
        else {
            error = EventError.cannotInvite
        }
    }
    
    func handleSendAsMessageTapped() {
        presentShareDialog = false
        presentSendAsMessageScreen = true
    }
    
    func fetchEventOwner() async {
        if self.eventOwner == nil {
            if let uid = event.createdBy, uid != "unclaimed" {
                self.eventOwner = await AccountClient.fetchAccount(accountId: uid)
            }
        }
    }
    
    func fetchEventComments(since: Date? = nil) async {
        do {
            let comments = try await CommentsClient.fetchComments(for: event.uid, since: since)
            if self.comments.isEmpty {
                self.comments = comments
            }
            else {
                self.comments.append(contentsOf: comments)
            }
            self.comments.sort{$0.date > $1.date}
            withAnimation {
                self.commentsViewModels = self.comments.map{EventCommentViewModel(comment: $0, event: event)}
            }
        }
        catch {
            self.error = error
        }
    }
    
    func sendCommentNotifiation() {
        guard let account = AccountManager.shared.account, let eventOwner = event.createdBy else { return }
        let notification = AppNotification(sender: account.uid,
                                           date: .now,
                                           type: .event_comment,
                                           notificationData: NotificationData(event_flyer_url: event.eventFlyerUrl,
                                                                              event_id: event.uid,
                                                                              event_name: event.eventName,
                                                                              profile_image_url: account.profileImageUrl,
                                                                              username: account.username))
        try? AppNotificationClient.saveNotification(for: eventOwner, notification: notification)
    }
    
    func saveComment() {
        guard let uid = AccountManager.shared.account?.uid else { return }
        do {
            let comment = Comment(date: .now,
                                  comment: commentText,
                                  account: uid)
            try CommentsClient.saveComment(for: event.uid, comment: comment)
            sendCommentNotifiation()
            self.commentText = ""
            let latestComment = self.comments.first?.date
            Task {
                await fetchEventComments(since: latestComment)
            }
        }
        catch {
            self.error = error
        }
    }
    
    func navigateToVenue() {
        guard let venueId = event.eventVenueId else {return}
        Task {
            guard let venue = await AccountClient.fetchAccount(accountId: venueId) else { return }
            let viewModel = ProfileViewModel(account: venue)
            Router.shared.navigateTo(.Profile(viewModel))
        }
    }
    
//    func getNumberOfComments() {
//        Task {
//            self.numberOfComments = await CommentsClient.getNumberOfComments(for: event.uid)
//        }
//    }
    
}
