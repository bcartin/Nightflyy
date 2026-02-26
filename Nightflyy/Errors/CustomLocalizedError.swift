//
//  CustomLocalizedError.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/7/24.
//

import Foundation

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

