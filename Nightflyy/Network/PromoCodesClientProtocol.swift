//
//  PromoCodesClientProtocol.swift
//  Nightflyy
//

import Foundation

protocol PromoCodesClientProtocol {
    func codeIsValid(code: String) async -> Bool
    func addRedemption(code: String)
}
