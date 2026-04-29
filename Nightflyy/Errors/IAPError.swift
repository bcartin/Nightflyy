//
//  IAPError.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 3/18/26.
//

import Foundation

enum IAPError: Error {
    case productNotFound
}

extension IAPError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .productNotFound:
            return "Product not found"
        }
    }
}
