//
//  City.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/6/24.
//

import Foundation

struct City: Identifiable, Codable {
    var id: String = UUID().uuidString
    var city: String
    var latitude: Double
    var longitude: Double
    var state: String
    
    var displayName: String {
        return city + ", " + state
    }
    
    enum CodingKeys: String, CodingKey {
        case city
        case latitude
        case longitude
        case state
    }
}

extension City: Equatable {
    static func == (lhs: City, rhs: City) -> Bool {
        return lhs.id == rhs.id
    }
}
