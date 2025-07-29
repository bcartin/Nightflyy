//
//  EventCommentViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/26/25.
//

import SwiftUI

@Observable
class EventCommentViewModel: NSObject {
    
    var comment: Comment
    var event: Event
    var account: Account?
    
    init(comment: Comment, event: Event) {
        self.comment = comment
        self.event = event
    }
    
    var numberOfLikes: String {
        return comment.likes.isEmpty ? "" : "\(comment.likes.count)"
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
