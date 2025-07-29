//
//  MessageType.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 1/30/25.
//

import Foundation

enum MessageType: String, Codable {
    case text = "text"
    case event = "event"
    case account = "account"
}

