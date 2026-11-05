//
//  SendgridManager.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/26/25.
//

import Foundation
import OSLog

enum SendgridLists {

    case ALL
    case NFPLUS
    case NONPLUS
    case VENUES

    var id: String {
        switch self {

        case .ALL:
            "ad03f078-b35c-4192-af90-4dd1e4dabbd8"
        case .NFPLUS:
            "b5d64c2e-8acc-4a2b-8b68-3555a02463d1"
        case .NONPLUS:
            "a133fb0d-ce21-4c07-a877-747a95ee4f7d"
        case .VENUES:
            "80c521f6-b00e-4701-abde-2d777fa3d812"
        }
    }

}

class SendgridManager {

    static func createContactInSendgrid(account: Account, lists: [SendgridLists]) async {
#if RELEASE
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM dd, yyyy"
        let dob = dateformatter.date(from: account.dob!)
        let dobString = dob?.stringValue(format: "MM/dd/yyyy")

        let contact = Contact(email: account.email,
                              externalId: account.uid,
                              firstName: account.name,
                              customFields: CustomFields(username: account.username, dob: dobString))

        let listIds = lists.map { $0.id }

        // TODO: add to all and non nightflyy lists, make list a parameter
        let body = ContactRequestBody(listIds: listIds, contacts: [contact])

        guard let request = ContactRequest(body: body) else { return }
        do {
            _ = try await addContacts(request: request)
        } catch {
            Logger.network.error("Error creating contact in Sendgrid: \(error.localizedDescription)")
            return
        }
#endif
    }

    private static func addContacts(request: ContactRequest) async throws -> ContactResponse {
        let (data, response) = try await URLSession.shared.data(for: request.httpRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ContactError.failureResponse
        }

        if httpResponse.statusCode == 202 {
            let decodedResponse = try JSONDecoder().decode(ContactResponse.self, from: data)
            return decodedResponse
        } else {
            throw ContactError.failureResponse
        }
    }

}
