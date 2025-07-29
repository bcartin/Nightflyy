//
//  Report.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/16/25.
//

import Foundation
import FirebaseFirestore

struct Report: Identifiable, Codable {
    
    @DocumentID var id = UUID().uuidString
    var reason: String
    var accountReported: String
    var reportedBy: String
    var notes: String?
    var date: Date
    
    enum CodingKeys: String, CodingKey {
        case reason
        case accountReported = "account_reported"
        case reportedBy = "reported_by"
        case notes
        case date
    }
}
