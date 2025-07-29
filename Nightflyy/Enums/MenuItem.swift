//
//  MenuItem.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/8/25.
//

import Foundation
import SwiftUI

enum MenuItem {
    case accountInfo(type: AccountType)
    case eventPreferences
    case privacy
    case pushNotifications
    case termsOfService
    case privacyPolicy
    case helpUs
    case rateUs
    case shareApp
    case logout
    
    var title: String {
        switch self {
        case .accountInfo:
            return "Edit Account Info"
        case .eventPreferences:
            return "Edit Event Preferences"
        case .privacy:
            return "Privacy Settings"
        case .pushNotifications:
            return "Push Notifications"
        case .termsOfService:
            return "Terms of Service"
        case .privacyPolicy:
            return "Privacy Policy"
        case .helpUs:
            return "Help Us Improve"
        case .rateUs:
            return "Rate Us"
        case .shareApp:
            return "Share App"
        case .logout:
            return "Logout"
        }
    }
    
    var image: String? {
        switch self {
        case .logout:
            return "rectangle.portrait.and.arrow.forward.fill"
        default:
            return nil
        }
    }
    
    @ViewBuilder var associatedView: some View {
        switch self {
        case .accountInfo(let type):
            switch type {
            case .personal:
                EditProfileView(viewModel: EditProfileViewModel())
            case .venue:
                EditVenueProfileView(viewModel: EditVenueProfileViewModel())
            }
            
        case .eventPreferences:
            EventPreferencesView(viewModel: EventPreferencesViewModel())
        case .privacy:
            PrivacySettingsView(viewModel: PrivacySettingsViewModel())
        case .pushNotifications:
            NotificationsSettingsView(viewModel: NotificationsSettingsViewModel())
        case .termsOfService:
            WebView(url: "https://e97102b0-88c2-4ee4-904c-69691920f0d7.usrfiles.com/ugd/e97102_09aa2bb299194714bc03598220220f40.pdf", title: "Terms of Service")
        case .privacyPolicy:
            WebView(url: "https://e97102b0-88c2-4ee4-904c-69691920f0d7.usrfiles.com/ugd/e97102_fb276717b86c41f7b3688c3d3a180c36.pdf", title: "Privacy Policy")
        case .helpUs:
            WebView(url: "https://docs.google.com/forms/d/e/1FAIpQLSfbmYUnsSO0WXux5ePm9xa795kjgSCEfME0pjJuqp9nZixVXg/viewform?embedded=true", title: "Help Us Improve")
            
        
        default:
            EmptyView()
        }
    }
}
