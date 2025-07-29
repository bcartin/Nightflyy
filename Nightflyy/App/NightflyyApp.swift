//
//  NightflyyApp.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/20/24.
//

import SwiftUI

@main
struct NightflyyApp: App {
    
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase
    
    @State private var appState = AppState.shared
    @State private var authenticationManager = AuthenticationManager.shared
    @State private var accountManager = AccountManager.shared
    @State private var chatsManager = ChatsManager.shared
    @State private var locationManager = LocationManager.shared
    @State private var eventsManager = EventsManager.shared
    @State private var toastsManager = ToastsManager.shared
    @State private var pushNotificationsManager = PushNotificationsManager.shared
    @State private var router = Router.shared
    @State var navigator: Navigator?

    var body: some Scene {
        WindowGroup {
                        
            ZStack {
                if authenticationManager.isSignedIn && !authenticationManager.isSigningUp {
                        ContentView()
                            .environment(\.managedObjectContext, persistenceController.container.viewContext)
                            .environment(appState)
                            .environment(accountManager)
                            .environment(chatsManager)
                            .environment(locationManager)
                            .environment(eventsManager)
                            .environment(toastsManager)
                            .environment(router)
                            .environment(authenticationManager)
                }
                else {
                    SignedOutView()
                        .environment(appState)
                        .environment(locationManager)
                        .environment(router)
                        .environment(authenticationManager)
                }
                
                if appState.isLoading {
                    LoadingView()
                }
                
                if appState.showSplashScreen {
                    SplashScreenView()
                }
                
                if appState.showUpdateScreen {
                    UpdateView()
                }
                
            }
            .task {
                MainCoordinator().initialAppSetup()
                navigator = Navigator(router: router)
                pushNotificationsManager.navigator = navigator
            }
            .onOpenURL { url in
                navigator?.handleUniversalLink(url: url)
            }
            .onChange(of: scenePhase) { _, newValue in
                switch newValue {
                    
                case .background:
                    print("App moved to background")
                case .inactive:
                    print("App moved to inactive")
                case .active:
                    print("App moved to active")
                    Task {
                        await RemoteConfigManager.shared.syncVariables()
                    }
                @unknown default:
                    break
                }
            }
            
        }
    }
}
