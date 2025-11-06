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
    
    override private init() {
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
        locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            permissionGranted = false
        case .authorizedWhenInUse:
            permissionGranted = true
            Task {
                await EventsManager.shared.fetchNearbyEvents()
            }
        case .denied, .restricted:
            permissionGranted = false
        case .authorizedAlways:
            permissionGranted = true
        default:
            permissionGranted = false
        }
    }
}

