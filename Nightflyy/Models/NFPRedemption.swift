//
//  NFPRedemption.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/12/25.
//

import Foundation
import FirebaseFirestore

struct NFPRedemption: Codable, Savable {
    static var collection: String = FirestoreCollections.NFPRedemptions.value
    
    @DocumentID var id = UUID().uuidString
    var venueID: String
    var venueName: String
    var city: String?
    var state: String?
    var date: Date
    var clientID: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case venueID = "venue_id"
        case venueName = "venue_name"
        case city
        case state
        case date
        case clientID = "client_id"
    }
}

extension NFPRedemption {
    
    func save() throws {
        do {
            try FirebaseManager.shared.db.collection(NFPRedemption.collection).document(id!).setData(from: self, merge: true)
        }
        catch {
            throw error
        }
    }
}
