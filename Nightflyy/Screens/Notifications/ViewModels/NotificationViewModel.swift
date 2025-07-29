//
//  NotificationViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/1/25.
//

import Foundation
import SwiftUI

@Observable
class NotificationViewModel: NSObject {
    
    var notification: AppNotification
    var error: Error?
    
    init(notification: AppNotification) {
        self.notification = notification
    }
    
    var userImageUrl: String {
        return notification.notificationData.profile_image_url ?? ""
    }
    
    var eventFlyerUrl: String? {
        return notification.notificationData.event_flyer_url
    }
    
    var timeReceived: String {
        return notification.date.timeAgo()
    }
    
    var notificationType: AppNotificationType {
        return notification.type
    }
    
    var hasUser: Bool {
        return notificationType != .event_assigned
    }
    
    var hasEvent: Bool {
        return notification.notificationData.event_id != nil
    }
    
    func buildMainLabel() -> Text {
        let username: String = notification.notificationData.username ?? ""
        return Text("\(Text(username).foregroundStyle(.white))\(hasUser ? " " : "")\(Text(notificationType.mainLabelText).foregroundStyle(.gray))")
    }
    
    @ViewBuilder
    func actionsView() -> some View {
        switch self.notificationType {
        case .follow_request:
            Button { [weak self] in
                self?.acceptFollowRequest()
                self?.deleteNotification()
            } label: {
                Text("Accept")
            }
            .tint(.mainPurple)
            
            Button { [weak self] in
                self?.deleteNotification()
            } label: {
                Text("Decline")
            }
            .tint(.gray)
        case .follow_accepted:
            deleteAction()
        case .follow_start:
            deleteAction()
        case .invite_to_event:
            Button { [weak self] in
                self?.markAsAttenging()
                self?.deleteNotification()
            } label: {
                Text("Going")
            }
            .tint(.mainPurple)
            
            Button { [weak self] in
                self?.markAsInterested()
                self?.deleteNotification()
            } label: {
                Text("Interested")
            }
            .tint(.onlineBlue)
            
            Button { [weak self] in
                self?.deleteNotification()
            } label: {
                Text("Ignore")
            }
            .tint(.gray)
        case .event_assigned:
            Button { [weak self] in
                self?.acceptEventAssigned()
                self?.deleteNotification()
            } label: {
                Text("Accept")
            }
            .tint(.mainPurple)
            
            Button { [weak self] in
                self?.goToEvent()
            } label: {
                Text("View Event")
            }
            .tint(.gray)
        case .event_going, .event_comment, .review_submitted, .event_created, .event_alert, .event_interested:
            deleteAction()
        }
    }
    
    @ViewBuilder
    func deleteAction() -> some View {
        Button { [weak self] in
            self?.deleteNotification()
        } label: {
            Text("Delete")
        }
        .tint(.red)
    }
    
    func deleteNotification() {
        guard let notificationId = notification.id else {return}
        withAnimation {
            AppNotificationsManager.shared.deleteNotification(withId: notificationId)
        }
    }
    
    func goToProfile() {
        Task {
            if let account = await AccountClient.fetchAccount(accountId: notification.sender) {
                let viewModel = ProfileViewModel(account: account)
                Router.shared.navigateTo(.Profile(viewModel))
            }
        }
    }
    
    func goToEvent() {
        guard let eventId =  notification.notificationData.event_id else { return }
        print(eventId)
        Task {
            if let event = await EventClient.fetchEvent(eventId: eventId) {
                let viewModel = EventViewModel(event: event)
                Router.shared.navigateTo(.Event(viewModel))
            }
        }
    }
    
    func markAsInterested() {
        guard let uid = AccountManager.shared.account?.uid, let eventId =  notification.notificationData.event_id else { return }
        Task {
            do {
                try await EventClient.addUserToInterested(eventId: eventId, uid: uid)
                try await EventClient.removeUserFromAttending(eventId: eventId, uid: uid)
                deleteNotification()
            }
            catch {
                self.error = error
            }
        }
    }
    
    func markAsAttenging() {
        guard let eventId =  notification.notificationData.event_id else { return }
        Task {
            do {
                guard var event = await EventClient.fetchEvent(eventId: eventId) else { return }
                try await EventAttendanceManager.shared.markAsAttenging(event: &event)
            }
            catch {
                self.error = error
            }
        }
    }
    
    func acceptFollowRequest() {
        Task {
            do {
                guard var newFollower = await AccountClient.fetchAccount(accountId: notification.sender) else { return }
                try await AccountManager.shared.acceptFollowRequest(from: &newFollower)
            }
            catch {
                self.error = error
            }
            
        }
    }
    
    func acceptEventAssigned() {
        guard let uid = AccountManager.shared.account?.uid, let eventId =  notification.notificationData.event_id else { return }
        Task {
            do {
                try await EventClient.setEventOwner(eventId: eventId, uid: uid)
                if let event = await EventClient.fetchEvent(eventId: eventId) {
                    EventsManager.shared.updateEventLists(with: event)
                }
            }
            catch {
                self.error = error
            }
        }
    }
}
