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

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let fileName: String = try! AppConfiguration.value(for: "FB_FILEPATH_NAME")
        let filePath = Bundle.main.path(forResource: fileName, ofType: "plist")
        
        guard let fileopts = FirebaseOptions(contentsOfFile: filePath!) else {
            assert(false, "Couldn't load config file")
            return true
        }
        FirebaseApp.configure(options: fileopts)
        
        #if RELEASE
        
        Task {
            await RemoteConfigManager.shared.syncVariables()
        }
        
        if let token: String = try? AppConfiguration.value(for: "MIXPANEL_TOKEN") {
            Mixpanel.initialize(token: token, trackAutomaticEvents: true)
        }
        #endif

        UNUserNotificationCenter.current().delegate = self
        
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
        
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(named: "MainPurple")
//        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).backgroundColor = UIColor(named: "BackgroundBlackLight")
        
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        PushNotificationsManager.shared.didRegisterForNotifications(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        print("Failed to register for notifications")
    }
}
