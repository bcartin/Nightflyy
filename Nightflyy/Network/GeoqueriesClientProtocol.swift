//
//  GeoqueriesClientProtocol.swift
//  Nightflyy
//

import Foundation
import CoreLocation

protocol GeoqueriesClientProtocol {
    func fetchEventsForLocation(_ location: CLLocation) async throws -> [Event]
    func fetchVenuesForLocation(_ location: CLLocation) async throws -> [Account]
}
