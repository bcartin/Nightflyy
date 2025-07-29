//
//  PushNotificationsManager.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/15/25.
//

import SwiftUI
import Firebase

@Observable
class PushNotificationsManager: NSObject, UIApplicationDelegate {
    
    static let shared = PushNotificationsManager()
    
    let unCenter = UNUserNotificationCenter.current()
    var authorizationStatus: UNAuthorizationStatus = .notDetermined
    var navigator: Navigator?
    
    private override init() {
        super.init()
        setPermission()
    }
    
    func requestPermission() throws {
        Task {
            if authorizationStatus == .notDetermined {
                if try await unCenter.requestAuthorization(options: [.alert, .badge, .sound]) {
                    configure()
                    saveToken()
                    setPermission()
                }
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
    }
    
    func didRegisterForNotifications(_ deviceToken: Data) {
        let apnsToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("APNs token: \(apnsToken)")
        Messaging.messaging().apnsToken = deviceToken
        subscribeToNotifications(target: .everyone)
    }
    
}

extension PushNotificationsManager: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        
        let userInfo = response.notification.request.content.userInfo
        navigator?.handlePushNotification(userInfo: userInfo)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.sound, .badge]
        //TODO: Present in app message
    }
    
}

extension PushNotificationsManager: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Token Received: ", fcmToken ?? "")
        saveToken()
    }
    
    func saveToken() {
        if let token = Messaging.messaging().fcmToken, var account = AccountManager.shared.account {
            account.token = token
            try? account.save()
        }
    }
    
    func subscribeToNotifications(target: PushNotificationTarget) {
        Messaging.messaging().subscribe(toTopic: target.rawValue)
    }
    
    func unsubscribeFromNotifications(target: PushNotificationTarget) {
        Messaging.messaging().unsubscribe(fromTopic: target.rawValue)
    }
}

extension PushNotificationsManager { // Local Notifications
    
    func perkReminderNotification(for date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Remember to use your Plus Perk ✅"
        content.sound = .default
        let dateComponents = Calendar.current.dateComponents(Set(arrayLiteral: Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute), from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "perk_reminder_notification", content: content, trigger: trigger)
        unCenter.add(request)
    }
    
    func deleteDateNotificationRequest(identifiers: [String]) {
        unCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
