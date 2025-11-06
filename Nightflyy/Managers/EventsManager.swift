//
//  EventsManager.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/26/24.
//

import Foundation
import CoreLocation

@Observable
class EventsManager {
    
    static let shared = EventsManager()
    var maxDistanceKm: Double = 40 // 40Km = 25 Miles
    var nearbyEvents: [Event] = []
    var locationEvents: [Event] = []
    var followingEvents: [Event] = []
    var attendingEvents: [Event] = []
    var invitedEvents: [Event] = []
    var interestedEvents: [Event] = []
    var hostingEvents: [Event] = []
    
    private init() {  }
    
    func fetchNearbyEvents() async {
        do {
            guard let location = LocationManager.shared.currentLocation else { return }
            nearbyEvents = try await fetchEventsForLocation(location)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func updateEventLocations() {
        Task {
            let snapshot = try? await FirebaseManager.shared.db.collection(FirestoreCollections.Events.value).whereField("end_date", isGreaterThan: Date()).getDocuments()
            let events = try snapshot?.documents.map({ document in
                return try document.data(as: Event.self)
            })
            events?.forEach({ event in
                var event = event
                event.latitude = event.location?.latitude
                event.longitude = event.location?.longitude
                try? event.save()
            })
        }
    }
    
    func fetchEventsForLocation(_ location: CLLocation) async throws -> [Event] {
        var events = [Event]()
        do {
        
            let greaterCoordinates = makeGreaterQueryCoordinates(center: location.coordinate, maxDistanceKm: maxDistanceKm)
            let lesserCoordinates = makeLesserQueryCoordinates(center: location.coordinate, maxDistanceKm: maxDistanceKm)
            
            let eventsRef = FirebaseManager.shared.db.collection(FirestoreCollections.Events.value)
                .whereField("lng", isGreaterThanOrEqualTo: greaterCoordinates.longitude)
                .whereField("lng", isLessThanOrEqualTo: lesserCoordinates.longitude)
                .whereField("lat", isGreaterThanOrEqualTo: greaterCoordinates.latitude)
                .whereField("lat", isLessThanOrEqualTo: lesserCoordinates.latitude)
                .whereField("end_date", isGreaterThan: Date())
            let snapshot = try await eventsRef.getDocuments()
            let documents = snapshot.documents
            let filteredEvents = try documents.compactMap { document in
                let event = try document.data(as: Event.self)
                if event.isFutureEvent && !(event.eventIsPrivate ?? false) {
                    return event
                }
                return nil
            }
            events.append(contentsOf: filteredEvents)
            events.sort{$0.startDate ?? .init() < $1.startDate ?? .init()}
        }
        catch {
            throw error
        }
        return events
    }
    
    func setLocationEvents(_ location: CLLocation) {
        Task {
            do {
                self.locationEvents = try await fetchEventsForLocation(location)
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func maxDistanceToLoc(center: CLLocationCoordinate2D, maxDistanceKm: Double) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: maxDistanceKm / 110.574,
            longitude: maxDistanceKm / (111.320 * cos(center.latitude * .pi / 180))
        )
    }
    
    func makeGreaterQueryCoordinates(center: CLLocationCoordinate2D, maxDistanceKm: Double) -> CLLocationCoordinate2D {
        let range = maxDistanceToLoc(center: center, maxDistanceKm: maxDistanceKm)
        let lat = center.latitude - range.latitude
        let long = center.longitude - range.longitude
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    func makeLesserQueryCoordinates(center: CLLocationCoordinate2D, maxDistanceKm: Double) -> CLLocationCoordinate2D {
        let range = maxDistanceToLoc(center: center, maxDistanceKm: maxDistanceKm)
        let lat = center.latitude + range.latitude
        let long = center.longitude + range.longitude
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    func fetchFollowingEvents(account: Account) async {
        guard let followingIDs = account.following else { return }
        var events: [Event] = []
        await withTaskGroup(of: [Event]?.self) { group in
            for uid in followingIDs {
                group.addTask {
                    return await EventClient.fetchFutureEventsHostedBy(uid: uid)
                }
            }
            for await eventGroup in group {
                if let eventGroup = eventGroup?.filter({$0.isFutureEvent && !($0.eventIsPrivate ?? false)}) {
                    events.append(contentsOf: eventGroup)
                }
            }
        }
        events.sort(by: { $0.startDate ?? .init() < $1.startDate ?? .init()})
        self.followingEvents = events
    }
    
    func fetchHubEvents(refetch: Bool = false) async {
        await fetchAttendingEvents(refetch: refetch)
        await fetchInvitedEvents(refetch: refetch)
        await fetchInterestedEvents(refetch: refetch)
    }
    
    func fetchHostingEvents(refetch: Bool = false) async {
        guard let account = AccountManager.shared.account else { return }
        if hostingEvents.isEmpty || refetch {
            hostingEvents = await EventClient.fetchEventsHostedBy(uid: account.uid)
        }
    }
    
    func fetchAttendingEvents(refetch: Bool = false) async {
        guard let account = AccountManager.shared.account else { return }
        if attendingEvents.isEmpty || refetch {
            attendingEvents = await EventClient.fetchEventsAttending(uid: account.uid)
        }
    }
    
    func fetchInvitedEvents(refetch: Bool = false) async {
        guard let account = AccountManager.shared.account else { return }
        if invitedEvents.isEmpty || refetch {
            invitedEvents = await EventClient.fetchEventsInvited(uid: account.uid)
        }
    }
    
    func fetchInterestedEvents(refetch: Bool = false) async {
        guard let account = AccountManager.shared.account else { return }
        if interestedEvents.isEmpty || refetch {
            interestedEvents = await EventClient.fetchEventsInterested(uid: account.uid)
        }
    }
    
    func updateEventLists(with event: Event) {
        updateEventList(with: event, list: &nearbyEvents)
        updateEventList(with: event, list: &locationEvents)
        updateEventList(with: event, list: &followingEvents)
        updateEventList(with: event, list: &attendingEvents)
        updateEventList(with: event, list: &invitedEvents)
        updateEventList(with: event, list: &interestedEvents)
    }
    
    func updateEventList(with event: Event, list: inout [Event]) {
        if let index = list.firstIndex(where: {$0.uid == event.uid}) {
            list[index] = event
        }
    }

}
