//
//  CommentsClient.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/25/25.
//

import Foundation
import FirebaseFirestore

class CommentsClient {
    
    static func fetchComments(for eventId: String, since: Date? = nil) async throws -> [Comment] {
        var comments: [Comment] = .init()
        let date = since ?? Date().addingTimeInterval(-10000000)
        let query = FirebaseManager.shared.db.collection(FirestoreCollections.Events.value).document(eventId).collection(FirestoreCollections.Events.comments)
            .whereField(FirestoreCollections.GenericFields.date, isGreaterThan: date)
        let snapshot = try await query.getDocuments()
        comments = try snapshot.documents.map({ document in
            return try document.data(as: Comment.self)
        })
        return comments
    }
    
    static func getNumberOfComments(for eventId: String) async -> Int {
        do {
            let query = FirebaseManager.shared.db.collection(FirestoreCollections.Events.value).document(eventId).collection(FirestoreCollections.Events.comments)
            let countQuery = query.count
            let snapshot = try await countQuery.getAggregation(source: .server)
            return Int(truncating: snapshot.count)
        }
        catch {
            return 0
        }
    }
    
    static func saveComment(for eventId: String, comment: Comment) throws {
        let ref = FirebaseManager.shared.db.collection(FirestoreCollections.Events.value).document(eventId).collection(FirestoreCollections.Events.comments)
        try ref.addDocument(from: comment)
    }
    
    static func likeComment(eventId: String, commentId: String) async throws {
        guard let uid = AccountManager.shared.account?.uid else {return}
        try await FirebaseManager.shared.db.collection(FirestoreCollections.Events.value)
            .document(eventId)
            .collection(FirestoreCollections.Events.comments)
            .document(commentId)
            .updateData([
                FirestoreCollections.Events.likes: FieldValue.arrayUnion([uid])
            ])
    }
    
}
