//
//  EventsManager.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/26/24.
//

import Foundation
import CoreLocation
import OSLog

@Observable
class EventsManager {
    
    static let shared = EventsManager()
    var nearbyEvents: [Event] = []
    var locationEvents: [Event] = []
    var followingEvents: [Event] = []
    var attendingEvents: [Event] = []
    var invitedEvents: [Event] = []
    var interestedEvents: [Event] = []
    var hostingEvents: [Event] = []
    var locationVenues: [Account] = []
    
    private let eventClient: any EventClientProtocol
    private let geoClient: any GeoqueriesClientProtocol
    
    private init(
        eventClient: any EventClientProtocol = EventClient.shared,
        geoClient: any GeoqueriesClientProtocol = GeoqueriesClient.shared
    ) {
        self.eventClient = eventClient
        self.geoClient = geoClient
    }
    
    func fetchNearbyEvents() async {
        do {
            guard let location = LocationManager.shared.currentLocation else { return }
            nearbyEvents = try await geoClient.fetchEventsForLocation(location)
        }
        catch {
            Logger.general.error("Error fetching nearby events: \(error.localizedDescription)")
        }
    }
    
    func fetchNearbyVenues() async {
        do {
            locationVenues.removeAll()
            guard let location = LocationManager.shared.currentLocation else { return }
            locationVenues = try await geoClient.fetchVenuesForLocation(location)
        }
        catch {
            Logger.general.error("Error fetching nearby venues: \(error.localizedDescription)")
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
    
    func setLocationEvents(_ location: CLLocation) {
        Task {
            do {
                self.locationEvents = try await geoClient.fetchEventsForLocation(location)
            }
            catch {
                Logger.general.error("Error setting location events: \(error.localizedDescription)")
            }
        }
    }
    
    func setLocationVenues(_ location: CLLocation) {
        Task {
            do {
                locationVenues.removeAll()
                self.locationVenues = try await geoClient.fetchVenuesForLocation(location)
            }
            catch {
                Logger.general.error("Error setting location venues: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchFollowingEvents(account: Account) async {
        guard let followingIDs = account.following else { return }
        var events: [Event] = []
        await withTaskGroup(of: [Event]?.self) { [weak self] group in
            for uid in followingIDs {
                group.addTask {
                    return await self?.eventClient.fetchFutureEventsHostedBy(uid: uid)
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
            hostingEvents = await eventClient.fetchEventsHostedBy(uid: account.uid)
        }
    }
    
    func fetchAttendingEvents(refetch: Bool = false) async {
        guard let account = AccountManager.shared.account else { return }
        if attendingEvents.isEmpty || refetch {
            attendingEvents = await eventClient.fetchEventsAttending(uid: account.uid)
        }
    }
    
    func fetchInvitedEvents(refetch: Bool = false) async {
        guard let account = AccountManager.shared.account else { return }
        if invitedEvents.isEmpty || refetch {
            invitedEvents = await eventClient.fetchEventsInvited(uid: account.uid)
        }
    }
    
    func fetchInterestedEvents(refetch: Bool = false) async {
        guard let account = AccountManager.shared.account else { return }
        if interestedEvents.isEmpty || refetch {
            interestedEvents = await eventClient.fetchEventsInterested(uid: account.uid)
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
