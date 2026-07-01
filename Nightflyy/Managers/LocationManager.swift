//
//  LocationManager.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/26/24.
//

import Foundation
import CoreLocation

@Observable 
class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    let locationManager = CLLocationManager()
    
    var permissionGranted: Bool = false
    
    private let eventsManager: any EventsManaging
    private let authenticationManager: AuthenticationManager
    private let localNotificationsManager: LocalNotificationsManaging
    
    private init(
        eventsManager: any EventsManaging = EventsManager.shared,
        authenticationManager: AuthenticationManager = AuthenticationManager.shared,
        localNotificationsManager: LocalNotificationsManaging = LocalNotificationsManager.shared
    ) {
        self.eventsManager = eventsManager
        self.authenticationManager = authenticationManager
        self.localNotificationsManager = localNotificationsManager
        super.init()
        commonSetup();
    }
    
    var currentLocation: CLLocation? {
        locationManager.location
    }
    
    var permissionChosen: Bool {
        locationManager.authorizationStatus != .notDetermined
    }
    
    private func commonSetup() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func askPermission() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func startMonitoring() {
        locationManager.startMonitoringSignificantLocationChanges()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            permissionGranted = false
        case .authorizedWhenInUse:
            permissionGranted = true
            fetchRecords()
        case .denied, .restricted:
            permissionGranted = false
        case .authorizedAlways:
            permissionGranted = true
            fetchRecords()
        default:
            permissionGranted = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        fetchRecords()
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        // Only notify when the user is actually inside the region. Without this
        // guard, iOS reporting an `.outside`/`.unknown` state (which happens
        // every time monitoring starts) would fire a notification even when the
        // user is miles away from the venue.
        guard state == .inside else { return }
        sendVenueNotification(for: region)
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        sendVenueNotification(for: region)
    }
    
    func fetchRecords() {
        Task { [eventsManager] in
            guard let location = currentLocation else { return }
            await eventsManager.fetchNearbyEvents(for: location)
            await eventsManager.fetchNearbyVenues(for: location)
            await restartVenueMonitoring(for: eventsManager.locationVenues)
        }
    }
}


extension LocationManager {

    /// Minimum time that must elapse before the same venue can trigger another notification.
    private static let notificationDedupWindow: TimeInterval = 12 * 60 * 60

    /// Sends the venue welcome notification, unless one was already sent for the
    /// same venue within the last 12 hours. This prevents the repeated
    /// notifications caused by monitoring restarting on every location update.
    private func sendVenueNotification(for region: CLRegion) {
        let nearbyVenues = self.nearbyVenues()
        guard let venue = nearbyVenues.first(where: { $0.uid == region.identifier }) else {
            return
        }

        var timestamps: [String: Date] = UserDefaultsKeys.venueNotificationTimestamps.getValue() ?? [:]

        if let lastSent = timestamps[venue.uid],
           Date.now.timeIntervalSince(lastSent) < Self.notificationDedupWindow {
            return
        }

        let title = "Welcome to \(venue.name ?? "")✨"
        let body = "Tap here to get \(venue.perkName ?? "") 🥂"
        let data: [String: Any] = ["type": UniversalLinkType.venue.rawValue, "id": venue.uid]
        localNotificationsManager.sendLocalNotification(title: title, body: body, data: data)

        timestamps[venue.uid] = .now
        UserDefaultsKeys.venueNotificationTimestamps.setValue(timestamps)
    }

    func restartVenueMonitoring(for locations: [Account]) async {
        if authenticationManager.isSignedIn {
            await stopMonitoring()
            
            let nearbyVenues = self.nearbyVenues()
            for venue in nearbyVenues {
                let geofenceRegionCenter = CLLocationCoordinate2DMake(venue.getCLLocation().coordinate.latitude, venue.getCLLocation().coordinate.longitude)
                let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter,
                                                      radius: 50,
                                                      identifier: "\(venue.uid)")
                geofenceRegion.notifyOnEntry = true
                geofenceRegion.notifyOnExit = true
                
                self.locationManager.startMonitoring(for: geofenceRegion)
            }
        }
    }
    
    private func nearbyVenues() -> [Account] {
        guard let currentLocation = self.currentLocation else { return [] }
        
        let nearbyVenues = eventsManager.locationVenues
        let sortedClosest = nearbyVenues.filter{$0.plusProvider ?? false == true}.sorted(by: { $0.distance(to: currentLocation) < $1.distance(to: currentLocation)})
        return Array(sortedClosest.prefix(15))
    }
    
    func stopMonitoring() async {
        for region in self.locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
    }
}
