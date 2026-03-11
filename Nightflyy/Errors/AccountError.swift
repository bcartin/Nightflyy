//
//  AccountError.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 2/24/26.
//

import Foundation

enum AccountError: Error {
    
    case invalidUsername
    case usernameTaken
    case missingRequiredFields
    case passwordsDontMatch
    case passwordTooShort
    case invalidCode
    case invalidAge
    case invalidEmail

}

extension AccountError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
            
        case .invalidUsername:
            "Invalid Username"
        case .usernameTaken:
            "Username is already taken"
        case .missingRequiredFields:
            "Missing required fields"
        case .passwordsDontMatch:
            "Passwords do not match"
        case .passwordTooShort:
            "Password is too short"
        case .invalidCode:
            "Invalid code"
        case .invalidAge:
            "Must be over 18 to sign up"
        case .invalidEmail:
            "Invalid email address"
        }
    }
    
}
