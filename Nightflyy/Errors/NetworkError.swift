//
//  NetworkError.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 2/24/26.
//

import Foundation

enum NetworkError: LocalizedError {
    case noRecordFound
    case timeout
    case noConnection
    case unauthorized
    case serverError
    case decodingFailed
    
    var errorDescription: String? {
        switch self {
        case .noRecordFound:
            "Record not found"
        case .timeout:
            "The request timed out. Please try again."
        case .noConnection:
            "No internet connection. Please check your network settings."
        case .unauthorized:
            "You are not authorized to perform this action."
        case .serverError:
            "Something went wrong. Please try again later."
        case .decodingFailed:
            "Failed to process the server response."
        }
    }
}
