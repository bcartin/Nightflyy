//
//  Errors.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/7/24.
//

import Foundation

enum NetworkError: LocalizedError {
    case noRecordFound
}

struct CustomLocalizedError: LocalizedError {
    
    var error: Error
    
    var errorDescription: String? {
        return error.localizedDescription
    }
    
    init?(error: Error?) {
        guard let error = error else { return nil }
        self.error = error
    }
    
}


/// Account Errors
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


/// Event Errors

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

/// Signup Errors

enum SignupError: Error {
    
    case invalidCredentials
    case cannotProcessRequest
}

extension SignupError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
            
        case .invalidCredentials:
            "Invalid Credentials"
        case .cannotProcessRequest:
            "Cannot Process Your Request"
        }
    }
    
}

/// Nightflyy Plus Errors

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
