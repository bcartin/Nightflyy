//
//  RemoteConfigManager.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 7/25/25.
//

import Firebase

enum RemoteConfigParameter: String {
    
    case force_update
    case latest_app_version
    
}

class RemoteConfigManager {
    
    static let shared = RemoteConfigManager()
    
    private init() {}
    
    private let remoteConfig: RemoteConfig = {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        
        remoteConfig.addOnConfigUpdateListener { configUpdate, error in
            
            guard let configUpdate, error == nil else {
                print("RemoteConfigManager: Error listening for config updates: \(error?.localizedDescription ?? "N/A")")
                return
            }
            
            print("RemoteConfigManager: Updated Keys: \(configUpdate.updatedKeys)")
            
            Task {
                try? await remoteConfig.activate()
            }
        }
        
        return remoteConfig
    }()
    
    func syncVariables() async {
        do {
            let expirationDuration: TimeInterval = 720
            
            let status = try await remoteConfig.fetch(withExpirationDuration: expirationDuration)
            
            switch status {
            case .success:
                try await RemoteConfig.remoteConfig().activate()
                print("RemoteConfigManager: Varibles Synced")
            case .failure:
                print("RemoteConfigManager: Varible Syncing Failed")
            default:
                print("RemoteConfigManager: Varible Syncing Failed")
            }
        }
        catch {
            print("RemoteConfigManager: Error syncing variables: \(error.localizedDescription)")
        }
    }
}

extension RemoteConfigManager {
    
    func string(forKey key: RemoteConfigParameter) -> String {
        remoteConfig.configValue(forKey: key.rawValue).stringValue
    }
    
    func double(forKey key: RemoteConfigParameter) -> Double {
        remoteConfig.configValue(forKey: key.rawValue).numberValue.doubleValue
    }
    
    func bool(forKey key: RemoteConfigParameter) -> Bool {
        remoteConfig.configValue(forKey: key.rawValue).boolValue
    }
    
}
