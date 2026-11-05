//
//  Logger+Extensions.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/7/24.
//

import Foundation
import OSLog

extension Logger {

    enum Category: String {
        case auth = "AUTH"
        case network = "NETWORK"
        case general = "GENERAL"
        case IAP = "IAP"
        case config = "CONFIG"
        case search = "SEARCH"
    }

    private static var subsystem = Bundle.main.bundleIdentifier!

    static let auth = Logger(subsystem: subsystem, category: Category.auth.rawValue)
    static let network = Logger(subsystem: subsystem, category: Category.network.rawValue)
    static let general = Logger(subsystem: subsystem, category: Category.general.rawValue)
    static let iap = Logger(subsystem: subsystem, category: Category.IAP.rawValue)
    static let config = Logger(subsystem: subsystem, category: Category.config.rawValue)
    static let search = Logger(subsystem: subsystem, category: Category.search.rawValue)

}
