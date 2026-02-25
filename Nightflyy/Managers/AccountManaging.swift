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
    func followAccount(accountToFollow: inout Account) throws
    func unfollowAccount(accountToFollow: inout Account) throws
    func requestToFollowAccount(accountId: String) throws
    func acceptFollowRequest(from newFollower: inout Account) async throws
    func updateTrackInfo()
}
