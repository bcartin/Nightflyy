//
//  PushNotificationTarget.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/15/25.
//

import Foundation

enum PushNotificationTarget: String, CaseIterable {
    
    static var allValues: [String] {
        return allCases.map { $0.rawValue.capitalized }
    }
    
    case everyone
    case nfplus = "nightflyy_plus"
    case test
    
}
