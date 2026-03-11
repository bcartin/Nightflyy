//
//  CommentsClientProtocol.swift
//  Nightflyy
//

import Foundation

protocol CommentsClientProtocol {
    func fetchComments(for eventId: String, since: Date?) async throws -> [Comment]
    func getNumberOfComments(for eventId: String) async -> Int
    func saveComment(for eventId: String, comment: Comment) throws
    func likeComment(eventId: String, commentId: String) async throws
}
