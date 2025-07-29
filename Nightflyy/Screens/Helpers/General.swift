//
//  General.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/11/25.
//

import Foundation

class General {
    
    static func showSavedMessage() {
        ToastsManager.shared.showToast(label: "Saved", imageName: "checkmark.circle.fill")
    }
    
    static func showSuccessMessage(message: String, imageName: String = "checkmark.circle.fill") {
        ToastsManager.shared.showToast(label: message, imageName: imageName)
    }
}
