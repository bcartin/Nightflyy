//
//  EventClient.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/12/24.
//

import Foundation
import FirebaseFirestore
import OSLog

class EventClient {
    
    static let shared = EventClient()
    
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
            Logger.network.error("Error fetching event \(eventId): \(error.localizedDescription)")
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
            Logger.network.error("Error fetching events hosted by \(uid): \(error.localizedDescription)")
            return events
        }
        return events
    }
    
    static func fetchFutureEventsHostedBy(uid: String) async -> [Event] {
        var events: [Event] = .init()
        do {
            let eventsRef = FirebaseManager.shared.db.collection(FirestoreCollections.Events.value)
                .whereField(FirestoreCollections.Events.createdBy, isEqualTo: uid)
                .whereField("end_date", isGreaterThan: Date())
            let snapshot = try await eventsRef.getDocuments()
            events = try snapshot.documents.map({ document in
                return try document.data(as: Event.self)
            })
        }
        catch {
            Logger.network.error("Error fetching future events hosted by \(uid): \(error.localizedDescription)")
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
            Logger.network.error("Error fetching events attending for \(uid): \(error.localizedDescription)")
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
            Logger.network.error("Error fetching events invited for \(uid): \(error.localizedDescription)")
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
            Logger.network.error("Error fetching events interested for \(uid): \(error.localizedDescription)")
            return events
        }
        return events
    }
    
    static func addUserToAttending(eventId: String, uid: String) async throws {
        try await addToArrayField(eventId: eventId, field: FirestoreCollections.Events.attending, uid: uid)
    }
    
    static func addUserToInterested(eventId: String, uid: String) async throws {
        try await addToArrayField(eventId: eventId, field: FirestoreCollections.Events.interested, uid: uid)
    }
    
    static func addUserToInvited(eventId: String, uid: String) async throws {
        try await addToArrayField(eventId: eventId, field: FirestoreCollections.Events.invited, uid: uid)
    }
    
    static func removeUserFromAttending(eventId: String, uid: String) async throws {
        try await removeFromArrayField(eventId: eventId, field: FirestoreCollections.Events.attending, uid: uid)
    }
    
    static func removeUserFromInterested(eventId: String, uid: String) async throws {
        try await removeFromArrayField(eventId: eventId, field: FirestoreCollections.Events.interested, uid: uid)
    }
    
    static func removeUserFromInvited(eventId: String, uid: String) async throws {
        try await removeFromArrayField(eventId: eventId, field: FirestoreCollections.Events.invited, uid: uid)
    }
    
    private static func addToArrayField(eventId: String, field: String, uid: String) async throws {
        try await FirebaseManager.shared.db
            .collection(FirestoreCollections.Events.value)
            .document(eventId)
            .updateData([field: FieldValue.arrayUnion([uid])])
    }
    
    private static func removeFromArrayField(eventId: String, field: String, uid: String) async throws {
        try await FirebaseManager.shared.db
            .collection(FirestoreCollections.Events.value)
            .document(eventId)
            .updateData([field: FieldValue.arrayRemove([uid])])
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
    
    static func fetchEventByRedemptionCode(code: String) async throws -> Event? {
        let query = FirebaseManager.shared.db.collection(FirestoreCollections.Events.value)
            .whereField(FirestoreCollections.Events.perkRedemptionCode, isEqualTo: code)
        let snapshot = try await query.getDocuments()
        let document = snapshot.documents.first
        return try document?.data(as: Event.self)
    }
    
}
// MARK: - EventClientProtocol

extension EventClient: EventClientProtocol {
    func fetchEvent(eventId: String) async -> Event? {
        await Self.fetchEvent(eventId: eventId)
    }
    
    func fetchEventGroup(eventIds: [String]) async -> [Event] {
        await Self.fetchEventGroup(eventIds: eventIds)
    }
    
    func fetchEventsHostedBy(uid: String) async -> [Event] {
        await Self.fetchEventsHostedBy(uid: uid)
    }
    
    func fetchFutureEventsHostedBy(uid: String) async -> [Event] {
        await Self.fetchFutureEventsHostedBy(uid: uid)
    }
    
    func fetchEventsAttending(uid: String) async -> [Event] {
        await Self.fetchEventsAttending(uid: uid)
    }
    
    func fetchEventsInvited(uid: String) async -> [Event] {
        await Self.fetchEventsInvited(uid: uid)
    }
    
    func fetchEventsInterested(uid: String) async -> [Event] {
        await Self.fetchEventsInterested(uid: uid)
    }
    
    func addUserToAttending(eventId: String, uid: String) async throws {
        try await Self.addUserToAttending(eventId: eventId, uid: uid)
    }
    
    func addUserToInterested(eventId: String, uid: String) async throws {
        try await Self.addUserToInterested(eventId: eventId, uid: uid)
    }
    
    func addUserToInvited(eventId: String, uid: String) async throws {
        try await Self.addUserToInvited(eventId: eventId, uid: uid)
    }
    
    func removeUserFromAttending(eventId: String, uid: String) async throws {
        try await Self.removeUserFromAttending(eventId: eventId, uid: uid)
    }
    
    func removeUserFromInterested(eventId: String, uid: String) async throws {
        try await Self.removeUserFromInterested(eventId: eventId, uid: uid)
    }
    
    func removeUserFromInvited(eventId: String, uid: String) async throws {
        try await Self.removeUserFromInvited(eventId: eventId, uid: uid)
    }
    
    func setEventOwner(eventId: String, uid: String) async throws {
        try await Self.setEventOwner(eventId: eventId, uid: uid)
    }
    
    func deleteEvent(eventId: String) async throws {
        try await Self.deleteEvent(eventId: eventId)
    }
    
    func declineClaim(eventId: String) async throws {
        try await Self.declineClaim(eventId: eventId)
    }
    
    func fetchEventByRedemptionCode(code: String) async throws -> Event? {
        try await Self.fetchEventByRedemptionCode(code: code)
    }
}

