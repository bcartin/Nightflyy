//
//  AccountClientProtocol.swift
//  Nightflyy
//

import Foundation

protocol AccountClientProtocol {
    func saveCustomData(uid: String, data: [String: Any])
    func fetchAccount(accountId: String) async -> Account?
    func fetchAccountGroup(accountIds: [String]) async -> [Account]
    func fetchVenuesFrom(city: City) async -> [Account]
    func fetchNightflyyPlusProviders() async -> [Account]
    func fetchAccountReviews(for uid: String) async -> [Review]
    func getAccountReviewCount(for uid: String) async -> Int
    func fetchVenueByRedemptionCode(code: String) async throws -> Account?
    func removeFromRequested(accountId: String) async throws
    func submitReview(accountId: String, review: Review) throws
    func fetchNightflyyPlusMember() async -> [Account]
}
