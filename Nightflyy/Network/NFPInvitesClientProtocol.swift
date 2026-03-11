//
//  NFPInvitesClientProtocol.swift
//  Nightflyy
//

import Foundation

protocol NFPInvitesClientProtocol {
    func addInvite(to venueId: String) async throws
    func deleteInvites() async throws
}
