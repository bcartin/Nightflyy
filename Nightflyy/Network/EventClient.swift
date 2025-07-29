//
//  EventClient.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/12/24.
//

import Foundation
import FirebaseFirestore
//import FirebaseFirestoreSwift
import OSLog

class EventClient {
    
    static func fetchEvent(uid: String) async -> Result<Event, Error> {
        if let cached = firebaseCache[uid] {
            switch cached {
            case .event(let event):
                Logger.network.info("\(Logger.Category.Network.rawValue): Fetched event \(uid) from cache.")
                return .success(event)
            default:
                return .failure(NetworkError.noRecordFound)
            }
        }
        do {
            guard let event =  try await FirebaseManager.shared.getDocument(collection: FirestoreCollections.Events.value, documentId: uid, Event.self) else { return .failure(NetworkError.noRecordFound) }
            firebaseCache[uid] = .event(event)
            Logger.network.info("\(Logger.Category.Network.rawValue): Fetched event \(uid) from firebase.")
            return .success(event)
        }
        catch {
            return .failure(error)
        }
    }
    
    static func fetchEvent(eventId: String) async -> Event? {
        if let cached = firebaseCache[eventId] {
            switch cached {
            case .event(let event):
                Logger.network.info("\(Logger.Category.Network.rawValue): Fetched event \(eventId) from cache.")
                return event
            default:
                return nil
            }
        }
        do {
            let event = try await FirebaseManager.shared.getDocument(collection: FirestoreCollections.Events.value, documentId: eventId, Event.self)
            if let event = event {
                firebaseCache[eventId] = .event(event)
            }
            Logger.network.info("\(Logger.Category.Network.rawValue): Fetched event \(eventId) from firebase.")
            return event
        }
        catch {
            return nil
        }
    }
    
    static func fetchEventGroup(eventIds: [String]) async -> [Event] {
        var events: [Event] = .init()
        await withTaskGroup(of: Event?.self) { group in
            for uid in eventIds {
                group.addTask {
                    return await fetchEvent(eventId: uid)
                }
            }
            for await event in group {
                if let event = event {
                    events.append(event)
                }
            }
        }
        return events
    }
    
    static func fetchEventsHostedBy(uid: String) async -> [Event] {
        var events: [Event] = .init()
        do {
            let eventsRef = FirebaseManager.shared.db.collection(FirestoreCollections.Events.value)
                .whereField(FirestoreCollections.Events.createdBy, isEqualTo: uid)
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
    
    static func fetchEventsInvited(uid: String) async -> [Event] {
        var events: [Event] = .init()
        do {
            let eventsRef = FirebaseManager.shared.db.collection(FirestoreCollections.Events.value)
                .whereField(FirestoreCollections.Events.invited, arrayContains: uid)
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
    
    static func fetchEventsInterested(uid: String) async -> [Event] {
        var events: [Event] = .init()
        do {
            let eventsRef = FirebaseManager.shared.db.collection(FirestoreCollections.Events.value)
                .whereField(FirestoreCollections.Events.interested, arrayContains: uid)
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
    
    static func addUserToAttending(eventId: String, uid: String) async throws {
        try await FirebaseManager.shared.db
            .collection(FirestoreCollections.Events.value)
            .document(eventId)
            .updateData([
                FirestoreCollections.Events.attending: FieldValue.arrayUnion([uid])
            ])
    }
    
    static func addUserToInterested(eventId: String, uid: String) async throws {
        try await FirebaseManager.shared.db
            .collection(FirestoreCollections.Events.value)
            .document(eventId)
            .updateData([
                FirestoreCollections.Events.interested: FieldValue.arrayUnion([uid])
            ])
    }
    
    static func addUserToInvited(eventId: String, uid: String) async throws {
        try await FirebaseManager.shared.db
            .collection(FirestoreCollections.Events.value)
            .document(eventId)
            .updateData([
                FirestoreCollections.Events.invited: FieldValue.arrayUnion([uid])
            ])
    }
    
    static func removeUserFromAttending(eventId: String, uid: String) async throws {
        try await FirebaseManager.shared.db
            .collection(FirestoreCollections.Events.value)
            .document(eventId)
            .updateData([
                FirestoreCollections.Events.attending: FieldValue.arrayRemove([uid])
            ])
    }
    
    static func removeUserFromInterested(eventId: String, uid: String) async throws {
        try await FirebaseManager.shared.db
            .collection(FirestoreCollections.Events.value)
            .document(eventId)
            .updateData([
                FirestoreCollections.Events.interested: FieldValue.arrayRemove([uid])
            ])
    }
    
    static func removeUserFromInvited(eventId: String, uid: String) async throws {
        try await FirebaseManager.shared.db
            .collection(FirestoreCollections.Events.value)
            .document(eventId)
            .updateData([
                FirestoreCollections.Events.invited: FieldValue.arrayRemove([uid])
            ])
    }
    
    static func setEventOwner(eventId: String, uid: String) async throws {
        try await FirebaseManager.shared.db
            .collection(FirestoreCollections.Events.value)
            .document(eventId)
            .updateData([FirestoreCollections.Events.createdBy: uid])
    }
    
    static func deleteEvent(eventId: String) async throws {
        try await FirebaseManager.shared.db.collection(FirestoreCollections.Events.value).document(eventId).delete()
    }
    
    static func declineClaim(eventId: String) async throws {
        try await FirebaseManager.shared.db.collection(FirestoreCollections.Events.value).document(eventId).updateData([FirestoreCollections.Events.assigned_to: ""])
    }
    
}
