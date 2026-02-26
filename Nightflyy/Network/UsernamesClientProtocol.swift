//
//  UsernamesClientProtocol.swift
//  Nightflyy
//

import Foundation

protocol UsernamesClientProtocol {
    func isUsernameAvailable(_ username: String) async -> Bool
    func saveUsername(username: String) async
    func deleteUsername(username: String) async
}
