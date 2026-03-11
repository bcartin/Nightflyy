//
//  AccountManaging.swift
//  Nightflyy
//

import Foundation

protocol AccountManaging: AnyObject {
    var account: Account? { get set }
    var isPersonalAccount: Bool { get }
    var isPlusMember: Bool { get }
    var isPlusProvider: Bool { get }
    var isAdmin: Bool { get }
    func saveAccount()
    func fetchAccount(uid: String) async
    @discardableResult func followAccount(accountToFollow: Account) async throws -> Account
    @discardableResult func unfollowAccount(accountToFollow: Account) async throws -> Account
    func requestToFollowAccount(accountId: String) async throws
    @discardableResult func acceptFollowRequest(from newFollower: Account) async throws -> Account
    func updateTrackInfo()
}
