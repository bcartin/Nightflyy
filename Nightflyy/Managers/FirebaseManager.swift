//
//  FirebaseManager.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/7/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift
import FirebaseFunctions

class FirebaseManager {
    
    private init() {
        let settings = db.settings
        db.settings = settings
    }
    
    static let shared = FirebaseManager()
    
    lazy var functions = Functions.functions()
    
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    func getDocument<T>(collection: String, documentId: String, _ type: T.Type) async throws -> T? where T: Decodable {
        let docRef = self.db.collection(collection).document(documentId)
        do {
            return try await docRef.getDocument(as: type.self)
        }
        catch {
            throw error
        }
    }
}
