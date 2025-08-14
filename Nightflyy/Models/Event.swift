//
//  Event.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/5/24.
//

import Foundation
import FirebaseFirestore
//import FirebaseFirestoreSwift
//import CoreLocation

struct Event: Identifiable, Codable {
    static var collection: String = FirestoreCollections.Events.value
    
    @DocumentID var id = UUID().uuidString
    var assignedTo: String?
    var attending: [String]?
    var createdBy: String?
    var createdDate: Date?
    var endDate: Date?
    var endTime: String?
    var eventAddress: String?
    var eventCrowds: [String]?
    var eventDetails: String?
    var eventFlyerUrl: String?
    var eventIsFree: Bool?
    var eventIsPrivate: Bool?
    var eventMusic: [String]?
    var eventName: String?
    var eventVenue: String?
    var eventVenueId: String?
    var eventVenueType: String?
    var geohash: String?
    var guestsCanInvite: Bool?
    var interested: [String]?
    var invited: [String]?
    var hasNewPosts: Bool?
    var latitude: Double?
    var location: GeoPoint?
    var longitude: Double?
    var maxPrice: Int?
    var minPrice: Int?
    var rating: Float?
    var recurringID: String?
    var startDate: Date?
    var startTime: String?
    var status: String?
    var ticketingUrl: String?
    
    var uid: String {
        return self.id!
    }
    
    var isFutureEvent: Bool {
        return self.endDate ?? .init() > Date()
    }
    
    var isUnclaimed: Bool {
        return createdBy == "unclaimed"
    }
    
    func getAttendanceStatus(uid: String) -> AttendanceStatus {
        if let attending = self.attending, attending.contains(uid) {
            return .attending
        }
        if let interested = self.interested, interested.contains(uid) {
            return .interested
        }
        return .notAttending
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdBy = "created_by"
        case assignedTo = "assigned_to"
        case eventName = "event_name"
        case eventDetails = "event_details"
        case eventVenue = "event_venue"
        case eventVenueId = "event_venue_id"
        case eventAddress = "event_address"
        case startDate = "start_date"
        case startTime = "start_time"
        case endDate = "end_date"
        case endTime = "end_time"
        case eventIsPrivate = "event_is_private"
        case guestsCanInvite = "guests_can_invite"
        case eventVenueType = "event_venue_type"
        case eventMusic = "event_music"
        case eventCrowds = "event_crowds"
        case minPrice = "min_price"
        case maxPrice = "max_price"
        case eventIsFree = "event_is_free"
        case ticketingUrl = "ticketing_url"
        case eventFlyerUrl = "event_flyer_url"
        case attending
        case interested
        case invited
        case location = "l"
        case latitude = "lat"
        case longitude = "lng"
        case geohash = "g"
        case rating
        case status
        case recurringID = "recurring_id"
        case hasNewPosts = "has_new_posts"
    }
}

extension Event {
    
    func save() throws {
        do {
            _ = try FirebaseManager.shared.db.collection(Event.collection).document(id!).setData(from: self, merge: true)
        }
        catch {
            throw error
        }
    }
    
    func updateCache() {
        firebaseCache[uid] = .event(self)
    }

}
