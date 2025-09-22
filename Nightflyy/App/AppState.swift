//
//  AppState.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 10/9/24.
//

import SwiftUI

@Observable
class AppState {
    
    static let shared = AppState()
    
    private init() {}
    
    var isLoading: Bool = false
    
    var showSplashScreen = true
    
    var selectedTab = 0

    var showUpdateScreen: Bool {
        return (RemoteConfigManager.shared.string(forKey: .latest_app_version) > UIApplication.appVersion) && RemoteConfigManager.shared.bool(forKey: .force_update)
    }
}
