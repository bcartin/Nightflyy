//
//  MapsManager.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/23/25.
//

import CoreLocation
import UIKit

class MapsManager {
    
    static func getLocation(from address: String ) async -> CLLocation? {
        return try? await CLGeocoder().geocodeAddressString(address).first?.location
    }
    
    static func getCityAndState(from location: CLLocation) async -> String {
        let placemark = try? await CLGeocoder().reverseGeocodeLocation(location).first
        return "\(placemark?.locality ?? "City"), \(placemark?.administrativeArea ?? "ST")"
    }
    
    static func openMapsWithAddress(_ address: String) async {
        let location = await getLocation(from: address)
        if let coordinate = location?.coordinate {
            let url = URL(string: "maps://?saddr=&daddr=\(coordinate.latitude),\(coordinate.longitude)")
            if await UIApplication.shared.canOpenURL(url!) {
                await MainActor.run {
                    UIApplication.shared.open(url!)
                }
            }
        }
    }
    
}
