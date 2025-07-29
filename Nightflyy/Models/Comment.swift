//
//  Comment.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/25/25.
//

import Foundation
import FirebaseFirestore

struct Comment: Identifiable, Codable {
    
    @DocumentID var id = UUID().uuidString
    var date: Date
    var comment: String
    var account: String
    var likes: [String] = .init()
    
    var uid: String {
        return self.id!
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case comment
        case date
        case account
        case likes
    }
    
}
