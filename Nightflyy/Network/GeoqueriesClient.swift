//
//  GeoqueriesClient.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 12/10/25.
//

import Foundation
import FirebaseFirestore
import CoreLocation

class GeoqueriesClient {
    
    private static let maxDistanceKm: Double = 40 // 40Km = 25 Miles
    
    static func fetchEventsForLocation(_ location: CLLocation) async throws -> [Event] {
        let greaterCoordinates = makeGreaterQueryCoordinates(center: location.coordinate, maxDistanceKm: maxDistanceKm)
        let lesserCoordinates = makeLesserQueryCoordinates(center: location.coordinate, maxDistanceKm: maxDistanceKm)
        
        let eventsRef = FirebaseManager.shared.db.collection(FirestoreCollections.Events.value)
            .whereField("lng", isGreaterThanOrEqualTo: greaterCoordinates.longitude)
            .whereField("lng", isLessThanOrEqualTo: lesserCoordinates.longitude)
            .whereField("lat", isGreaterThanOrEqualTo: greaterCoordinates.latitude)
            .whereField("lat", isLessThanOrEqualTo: lesserCoordinates.latitude)
            .whereField("end_date", isGreaterThan: Date())
        let snapshot = try await eventsRef.getDocuments()
        let filteredEvents = try snapshot.documents.compactMap { document in
            let event = try document.data(as: Event.self)
            if event.isFutureEvent && !(event.eventIsPrivate ?? false) {
                return event
            }
            return nil
        }
        return filteredEvents.sorted { $0.startDate ?? .init() < $1.startDate ?? .init() }
    }
    
    static func fetchVenuesForLocation(_ location: CLLocation) async throws -> [Account] {
        let greaterCoordinates = makeGreaterQueryCoordinates(center: location.coordinate, maxDistanceKm: maxDistanceKm)
        let lesserCoordinates = makeLesserQueryCoordinates(center: location.coordinate, maxDistanceKm: maxDistanceKm)
        
        let queryRef = FirebaseManager.shared.db.collection(FirestoreCollections.Accounts.value)
            .whereField("lng", isGreaterThanOrEqualTo: greaterCoordinates.longitude)
            .whereField("lng", isLessThanOrEqualTo: lesserCoordinates.longitude)
            .whereField("lat", isGreaterThanOrEqualTo: greaterCoordinates.latitude)
            .whereField("lat", isLessThanOrEqualTo: lesserCoordinates.latitude)
            .whereField("account_type", isEqualTo: AccountType.venue.rawValue)
        let snapshot = try await queryRef.getDocuments()
        return try snapshot.documents.map { document in
            try document.data(as: Account.self)
        }
    }
    
    private static func maxDistanceToLoc(center: CLLocationCoordinate2D, maxDistanceKm: Double) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: maxDistanceKm / 110.574,
            longitude: maxDistanceKm / (111.320 * cos(center.latitude * .pi / 180))
        )
    }
    
    private static func makeGreaterQueryCoordinates(center: CLLocationCoordinate2D, maxDistanceKm: Double) -> CLLocationCoordinate2D {
        let range = maxDistanceToLoc(center: center, maxDistanceKm: maxDistanceKm)
        let lat = center.latitude - range.latitude
        let long = center.longitude - range.longitude
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    private static func makeLesserQueryCoordinates(center: CLLocationCoordinate2D, maxDistanceKm: Double) -> CLLocationCoordinate2D {
        let range = maxDistanceToLoc(center: center, maxDistanceKm: maxDistanceKm)
        let lat = center.latitude + range.latitude
        let long = center.longitude + range.longitude
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}
