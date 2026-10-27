//
//  EventViewModel+Comments.swift
//  Nightflyy
//

import SwiftUI

/// Event comments: loading, posting, notifying the owner and the owner's unread counter.
extension EventViewModel {

    var hasNewComments: Bool {
        event.newComments ?? 0 > 0
    }

    var newComments: String {
        guard let newComments = event.newComments else { return "" }
        return "\(newComments)"
    }

    func fetchEventComments() async {
        do {
            let latestComment = self.comments.first?.date.addingTimeInterval(1)
            let comments = try await CommentsClient.fetchComments(for: event.uid, since: latestComment)
            if self.comments.isEmpty {
                self.comments = comments
            } else {
                self.comments.append(contentsOf: comments)
            }
            self.comments.sort {$0.date > $1.date}
            withAnimation {
                self.commentsViewModels = self.comments.map {EventCommentViewModel(comment: $0, event: event)}
            }
        } catch {
            self.error = error
        }
    }

    func sendCommentNotifiation() {
        guard let account = AccountManager.shared.account, let eventOwner = event.createdBy else { return }
        let notification = AppNotification(sender: account.uid,
                                           date: .now,
                                           type: .eventComment,
                                           notificationData: NotificationData(eventFlyerUrl: event.eventFlyerUrl,
                                                                              eventId: event.uid,
                                                                              eventName: event.eventName,
                                                                              profileImageUrl: account.profileImageUrl,
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
            // Update the new comments counter
            let newComments = event.newComments ?? 0
            event.newComments = newComments + 1
            try event.save()

            // Send notification
            sendCommentNotifiation()
            self.commentText = ""

            // Fetch comments to display new comment on the list
            Task {
                await fetchEventComments()
            }
        } catch {
            self.error = error
        }
    }

    func updateCommentsCounter() {
        if isOwner {
            event.lastCommentsCheck = Date()
            event.newComments = 0
            do {
                try event.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
