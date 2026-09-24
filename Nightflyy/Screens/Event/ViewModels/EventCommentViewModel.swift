//
//  EventCommentViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/26/25.
//

import SwiftUI

@Observable @MainActor
class EventCommentViewModel: Hashable {
    
    nonisolated let id: String
    
    nonisolated static func == (lhs: EventCommentViewModel, rhs: EventCommentViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var comment: Comment
    var event: Event
    var account: Account?
    
    init(comment: Comment, event: Event) {
        self.id = comment.uid
        self.comment = comment
        self.event = event
    }
    
    var isOwner: Bool {
        return AccountManager.shared.account?.uid == event.createdBy
    }
    
    var numberOfLikes: String {
        return comment.likes.isEmpty ? "" : "\(comment.likes.count)"
    }
    
    var shouldHighlight: Bool {
        guard let lastCheck = event.lastCommentsCheck else { return false }
        return comment.date > lastCheck && isOwner
    }
    
    var haveLiked: Bool {
        guard let uid = AccountManager.shared.account?.uid else { return false }
        return comment.likes.contains(uid)
    }
    
    func fetchAccount() async {
        self.account = await AccountClient.fetchAccount(accountId: comment.account)
    }
    
    func likeComment() {
        Task {
            try? await CommentsClient.likeComment(eventId: event.uid, commentId: comment.uid)
            guard let uid = AccountManager.shared.account?.uid else { return }
            comment.likes.append(uid)
        }
    }
    
}
