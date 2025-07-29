//
//  Contact.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/26/25.
//

import Foundation

struct ContactReponse: Codable {
    let job_id: String?
}

struct ContactRequestBody: Codable {
    
    let list_ids: [String]?
    let contacts: [Contact]?
}

struct Contact: Codable {
    
    let email: String?
    let external_id: String?
    let first_name: String?
    let custom_fields: CustomFields?
}

struct CustomFields: Codable {
    
    let username: String?
    let dob: String?
}


enum ContactError: Error {
    
    case failureReponse
    
}
