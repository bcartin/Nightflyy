//
//  EventClientProtocol.swift
//  Nightflyy
//

import Foundation

protocol EventClientProtocol {
    func fetchEvent(eventId: String) async -> Event?
    func fetchEventGroup(eventIds: [String]) async -> [Event]
    func fetchEventsHostedBy(uid: String) async -> [Event]
    func fetchFutureEventsHostedBy(uid: String) async -> [Event]
    func fetchEventsAttending(uid: String) async -> [Event]
    func fetchEventsInvited(uid: String) async -> [Event]
    func fetchEventsInterested(uid: String) async -> [Event]
    func addUserToAttending(eventId: String, uid: String) async throws
    func addUserToInterested(eventId: String, uid: String) async throws
    func addUserToInvited(eventId: String, uid: String) async throws
    func removeUserFromAttending(eventId: String, uid: String) async throws
    func removeUserFromInterested(eventId: String, uid: String) async throws
    func removeUserFromInvited(eventId: String, uid: String) async throws
    func setEventOwner(eventId: String, uid: String) async throws
    func deleteEvent(eventId: String) async throws
    func declineClaim(eventId: String) async throws
    func fetchEventByRedemptionCode(code: String) async throws -> Event?
}
