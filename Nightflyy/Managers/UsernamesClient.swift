//
//  UsernamesManager.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/10/25.
//

import SwiftUI

@Observable
class UsernamesManager {
    
    static let shared = UsernamesManager()
    
    private init() {}
    
    static func fetchEventsAttending(uid: String) async -> [Event] {
        var events: [Event] = .init()
        do {
            let eventsRef = FirebaseManager.shared.db.collection(FirestoreCollections.Events.value)
                .whereField(FirestoreCollections.Events.attending, arrayContains: uid)
                .whereField(FirestoreCollections.Events.endDate, isGreaterThan: Date())
            let snapshot = try await eventsRef.getDocuments()
            events = try snapshot.documents.map({ document in
                return try document.data(as: Event.self)
            })
        }
        catch {
            return events
        }
        return events
    }
    
}
