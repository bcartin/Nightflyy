//
//  EventsManaging.swift
//  Nightflyy
//

import Foundation
import CoreLocation

protocol EventsManaging: AnyObject {
    var nearbyEvents: [Event] { get set }
    var locationEvents: [Event] { get set }
    var followingEvents: [Event] { get set }
    var attendingEvents: [Event] { get set }
    var invitedEvents: [Event] { get set }
    var interestedEvents: [Event] { get set }
    var hostingEvents: [Event] { get set }
    var locationVenues: [Account] { get set }
    func fetchNearbyEvents() async
    func fetchNearbyVenues() async
    func fetchFollowingEvents(account: Account) async
    func fetchHubEvents(refetch: Bool) async
    func fetchHostingEvents(refetch: Bool) async
    func fetchAttendingEvents(refetch: Bool) async
    func fetchInvitedEvents(refetch: Bool) async
    func fetchInterestedEvents(refetch: Bool) async
    func updateEventLists(with event: Event)
    func setLocationEvents(_ location: CLLocation)
    func setLocationVenues(_ location: CLLocation)
}
