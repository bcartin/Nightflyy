//
//  SignupError.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 2/24/26.
//

import Foundation

enum SignupError: Error {
    
    case invalidCredentials
    case cannotProcessRequest
    case noReferralVenueSelected
}

extension SignupError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
            
        case .invalidCredentials:
            "Invalid Credentials"
        case .cannotProcessRequest:
            "Cannot Process Your Request"
        case .noReferralVenueSelected:
            "Please select a referral venue."
        }
    }
    
}
