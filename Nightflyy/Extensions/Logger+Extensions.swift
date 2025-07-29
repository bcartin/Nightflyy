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
    }
    
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    static let auth = Logger(subsystem: subsystem, category: Category.Auth.rawValue)
    static let network = Logger(subsystem: subsystem, category: Category.Network.rawValue)
    
}
