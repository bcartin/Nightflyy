//
//  NFPError.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 2/24/26.
//

import Foundation

enum NFPError: Error {
    case invalidCode
}

extension NFPError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
            
        case .invalidCode:
            "Invalid Promo Code. Please Try Again."
        }
    }
}
