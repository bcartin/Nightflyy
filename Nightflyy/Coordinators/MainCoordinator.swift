//
//  MainCoordinator.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/21/25.
//

import Foundation

class MainCoordinator {
    
    func initialAppSetup() {
        Task {
            AuthenticationManager.shared.checkAuthState() 
            guard let uid = AuthenticationManager.shared.currentUser?.uid else { return } //MARK: if it should do something when not logged in do it before this line
//                                let uid = "Ya2VB47Ei2QlfN4XB25BOUgoM6S2" //TODO: remove
            AnalyticsManager.setUserID(value: uid)
            await AccountManager.shared.fetchAccount(uid: uid)
            await EventsManager.shared.initialEventFetch()
            await NFPManager.shared.checkSubscriptionStatus()
            AppState.shared.showSplashScreen = false
            await ChatsManager.shared.initChatsListener(uid: uid)
        }
    }
    
    func setUpInAppPurchases() {
        Task {
            do {
                let qonversionKey: String = try AppConfiguration.value(for: "QONVERSION_KEY")
                let result = IAPManager.shared.configure(with: qonversionKey)
                if result {
                    print("Qonversion set up successfully.")
                    _ = try await IAPManager.shared.checkPermissions()
                }
            }
            catch {
                print("Error setting up qonversion: ", error.localizedDescription)
            }
        }
    }
    
}
