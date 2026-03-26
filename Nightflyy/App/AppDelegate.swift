//
//  AppDelegate.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/23/24.
//

import Foundation
import UIKit
import Firebase
import Mixpanel
import Airbridge

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        do {
            let fileName: String = try AppConfiguration.value(for: "FB_FILEPATH_NAME")
            guard let filePath = Bundle.main.path(forResource: fileName, ofType: "plist") else {
                fatalError("Failed to load AppConfiguration")
            }
            
            guard let fileopts = FirebaseOptions(contentsOfFile: filePath) else {
                assert(false, "Couldn't load config file")
                return true
            }
            FirebaseApp.configure(options: fileopts)
            UIApplication.shared.registerForRemoteNotifications()
            Messaging.messaging().delegate = PushNotificationsManager.shared
        }
        catch {
            fatalError("Failed to load AppConfiguration")
        }
        
        #if RELEASE
        
        //MARK: Setup Remote Config
        Task {
            await RemoteConfigManager.shared.syncVariables()
        }
        
        //MARK: Setup Mix Panel
        if let token: String = try? AppConfiguration.value(for: "MIXPANEL_TOKEN") {
            Mixpanel.initialize(token: token, trackAutomaticEvents: true)
        }
        
        //MARK: Setup Airbridge
        if let token: String = try? AppConfiguration.value(for: "AIRBRIDGE_TOKEN"), let appname: String = try? AppConfiguration.value(for: "APPNAME") {
            let option = AirbridgeOptionBuilder(name: appname, token: token)
                .setAutoDetermineTrackingAuthorizationTimeout(second: 0)
                .build()
            Airbridge.initializeSDK(option: option)
        }
        #endif
        
        let coordinator = MainCoordinator()
        coordinator.setUpInAppPurchases()
        coordinator.initialAppSetup()
        
        configureAppearance()

        return true
    }
    
    func configureAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .backgroundBlack
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().standardAppearance = tabBarAppearance
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .backgroundBlack
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        
        UISegmentedControl.appearance().selectedSegmentTintColor = .mainPurple
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(named: "MainPurple")        
    }
}

