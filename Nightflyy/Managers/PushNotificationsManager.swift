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
class PushNotificationsManager: NSObject, UIApplicationDelegate {
    
    static let shared = PushNotificationsManager()
    
    let unCenter = UNUserNotificationCenter.current()
    var authorizationStatus: UNAuthorizationStatus = .notDetermined
    var userInfo: [AnyHashable: Any]?
    var navigator: Navigator? {
        didSet {
            handlePendingPushNotification()
        }
    }
    
    private override init() {
        super.init()
        setPermission()
    }
    
    func requestPermission() async throws {
        if authorizationStatus == .notDetermined {
            if try await unCenter.requestAuthorization(options: [.alert, .badge, .sound]) {
                configure()
                saveToken()
                setPermission()
            }
        }
    }
    
    func setPermission() {
        Task {
            let settings = await unCenter.notificationSettings()
            self.authorizationStatus = settings.authorizationStatus
        }
    }
    
    func configure() {
        unCenter.delegate = self
        UIApplication.shared.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        subscribeToTester()
    }
    
    func didRegisterForNotifications(_ deviceToken: Data) {
        let apnsToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        #if DEBUG
        print("APNs token: \(apnsToken)")
        #endif
        Messaging.messaging().apnsToken = deviceToken
        subscribeToNotifications(target: .everyone)
    }
    
    func subscribeToTester() {
        if AccountManager.shared.account?.isTester ?? false {
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
        #if DEBUG
        print("Token Received: ", fcmToken ?? "")
        if let apnsToken = messaging.apnsToken {
            print("APNs Token: ", apnsToken)
        }
        #endif
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
