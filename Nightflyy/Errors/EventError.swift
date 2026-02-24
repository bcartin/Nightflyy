//
//  EventError.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 2/24/26.
//

import Foundation

enum EventError: Error {
    
    case missingRequiredFields
    case cannotInvite
}

extension EventError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
            
        case .missingRequiredFields:
            "Missing required fields"
        case .cannotInvite:
            "You cannot invite other guests to this event"
        }
        
    }
    
}
