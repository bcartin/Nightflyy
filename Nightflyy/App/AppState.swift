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
    
    var selectedTab: AppTab = .home

    var showUpdateScreen: Bool {
        let appVersion = UIApplication.appVersion
        let remoteConfigAppVersion = RemoteConfigManager.shared.string(forKey: .latest_app_version)
        let result = remoteConfigAppVersion.compare(appVersion, options: .numeric)
        return result == .orderedDescending && RemoteConfigManager.shared.bool(forKey: .force_update)
    }
}
