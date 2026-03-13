//
//  PushNotificationsManager.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/15/25.
//

import SwiftUI
import Firebase
import FirebaseAuth

@Observable
class PushNotificationsManager: NSObject, UIApplicationDelegate, PushNotificationsManaging {
    
    static let shared = PushNotificationsManager()
    
    let unCenter = UNUserNotificationCenter.current()
    var authorizationStatus: UNAuthorizationStatus = .notDetermined
    var userInfo: [AnyHashable: Any]?
    var navigator: Navigator? {
        didSet {
            handlePendingPushNotification()
        }
    }
    
    private let accountManager: any AccountManaging
    
    private init(
        accountManager: any AccountManaging = AccountManager.shared
    ) {
        self.accountManager = accountManager
        super.init()
        unCenter.delegate = self
    }
    
    func requestPermission() async throws {
        await refreshAuthorizationStatus()

        if authorizationStatus == .notDetermined {
            if try await unCenter.requestAuthorization(options: [.alert, .badge, .sound]) {
                configure()
                saveToken()
                await refreshAuthorizationStatus()
            }
        }
        else if authorizationStatus == .authorized {
            configure()
            saveToken()
        }
    }
    
    /// Fetches the current notification authorization status from the system.
    func refreshAuthorizationStatus() async {
        let settings = await unCenter.notificationSettings()
        self.authorizationStatus = settings.authorizationStatus
    }
    
    func configure() {
        subscribeToTester()
    }
    
    func didRegisterForNotifications(_ deviceToken: Data) {
        let apnsToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
//        #if DEBUG
        print("APNs token: \(apnsToken)")
//        #endif
        Messaging.messaging().apnsToken = deviceToken
        subscribeToNotifications(target: .everyone)
    }
    
    func subscribeToTester() {
        if accountManager.account?.isTester ?? false {
            subscribeToNotifications(target: .test)
        }
    }
    
}

extension PushNotificationsManager: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        
        userInfo = response.notification.request.content.userInfo
        handlePendingPushNotification()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.sound, .badge]
        //TODO: Present in app message
    }
    
    func handlePendingPushNotification () {
        guard let userInfo else { return }
        navigator?.handlePushNotification(userInfo: userInfo)
        self.userInfo = nil
    }
    
}

extension PushNotificationsManager: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        #if DEBUG
        print("Token Received: ", fcmToken ?? "")
        if let apnsToken = messaging.apnsToken {
            print("APNs Token: ", apnsToken)
        }
//        #endif
        saveToken(token: fcmToken)
    }
    
    func saveToken(token: String? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if let token = token {
            AccountClient.saveCustomData(uid: uid, data: [FirestoreCollections.Accounts.token: token])
        }
        else if let token = Messaging.messaging().fcmToken {
            AccountClient.saveCustomData(uid: uid, data: [FirestoreCollections.Accounts.token: token])
        }
    }
    
    func subscribeToNotifications(target: PushNotificationTarget) {
        Messaging.messaging().subscribe(toTopic: target.rawValue)
    }
    
    func unsubscribeFromNotifications(target: PushNotificationTarget) {
        Messaging.messaging().unsubscribe(fromTopic: target.rawValue)
    }
}


//MARK: App Delegate Extension
extension AppDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        PushNotificationsManager.shared.didRegisterForNotifications(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        print("Failed to register for notifications")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        PushNotificationsManager.shared.userInfo = response.notification.request.content.userInfo
    }
}
