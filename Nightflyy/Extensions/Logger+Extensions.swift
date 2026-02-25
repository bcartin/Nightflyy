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
        case Auth = "AUTH"
        case Network = "NETWORK"
        case General = "GENERAL"
        case IAP = "IAP"
        case Config = "CONFIG"
        case Search = "SEARCH"
    }
    
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    static let auth = Logger(subsystem: subsystem, category: Category.Auth.rawValue)
    static let network = Logger(subsystem: subsystem, category: Category.Network.rawValue)
    static let general = Logger(subsystem: subsystem, category: Category.General.rawValue)
    static let iap = Logger(subsystem: subsystem, category: Category.IAP.rawValue)
    static let config = Logger(subsystem: subsystem, category: Category.Config.rawValue)
    static let search = Logger(subsystem: subsystem, category: Category.Search.rawValue)
    
}
