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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
