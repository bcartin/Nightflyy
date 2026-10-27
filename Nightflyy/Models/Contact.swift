//
//  Contact.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/26/25.
//

import Foundation

// Sendgrid Marketing Contacts API; JSON keys are snake_case.

struct ContactResponse: Codable {
    let jobId: String?

    enum CodingKeys: String, CodingKey {
        case jobId = "job_id"
    }
}

struct ContactRequestBody: Codable {

    let listIds: [String]?
    let contacts: [Contact]?

    enum CodingKeys: String, CodingKey {
        case listIds = "list_ids"
        case contacts
    }
}

struct Contact: Codable {

    let email: String?
    let externalId: String?
    let firstName: String?
    let customFields: CustomFields?

    enum CodingKeys: String, CodingKey {
        case email
        case externalId = "external_id"
        case firstName = "first_name"
        case customFields = "custom_fields"
    }
}

struct CustomFields: Codable {

    let username: String?
    let dob: String?
}
