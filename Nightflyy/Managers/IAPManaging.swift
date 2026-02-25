//
//  IAPManaging.swift
//  Nightflyy
//

import Foundation

protocol IAPManaging {
    func checkPermissions() async throws -> Bool
    func purchase(venue: Account?) async throws -> Bool
    func restorePurchases() async throws
}
