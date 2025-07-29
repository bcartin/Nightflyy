//
//  Chat.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/22/24.
//

import Foundation
import FirebaseFirestore
//import FirebaseFirestoreSwift

struct Chat: Codable, Identifiable, Savable {
    static var collection: String = FirestoreCollections.Chats.value
    
    @DocumentID var id = UUID().uuidString
    var lastMessage: String?
    var lastUpdated: Date?
    var isNew: Bool?
    var lastMessageSender: String?
    var members: [String]
    
    var uid: String {
        return self.id!
    }
        
    enum CodingKeys: String, CodingKey {
        case id
        case isNew = "is_new"
        case lastMessage = "last_message"
        case lastMessageSender = "last_message_sender"
        case lastUpdated = "last_updated"
        case members
    }
}

extension Chat {
    
    func save() throws {
        do {
            try FirebaseManager.shared.db.collection(Chat.collection).document(id!).setData(from: self, merge: true)
        }
        catch {
            throw error
        }
    }
}
