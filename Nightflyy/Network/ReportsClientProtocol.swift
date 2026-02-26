//
//  ReportsClientProtocol.swift
//  Nightflyy
//

import Foundation

protocol ReportsClientProtocol {
    func submitReport(report: Report) throws
    func blockAccount(accountId: String) async throws
}
