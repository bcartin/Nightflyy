//
//  Review.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/22/25.
//

import Foundation
import FirebaseFirestore

struct Review: Identifiable, Codable {
    
    @DocumentID var id = UUID().uuidString
    var reviewer: String
    var rating: Int
    var likes: [String]?
    var dislikes: [String]?
    var date: Date
    
    enum CodingKeys: String, CodingKey {
        case reviewer
        case rating
        case likes
        case dislikes
        case date
    }
}
