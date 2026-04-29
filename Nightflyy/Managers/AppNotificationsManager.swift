//
//  AppNotificationsManager.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/1/25.
//

import SwiftUI
import CoreData
import OSLog

@Observable @MainActor
class AppNotificationsManager {

    static let shared = AppNotificationsManager()

    var notifications: [AppNotification] = .init()

    private let notificationClient: any AppNotificationClientProtocol
    private let viewContext: NSManagedObjectContext

    private init(
        notificationClient: any AppNotificationClientProtocol = AppNotificationClient.shared,
        viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    ) {
        self.notificationClient = notificationClient
        self.viewContext = viewContext
    }

    func fetchNotifications(refetch: Bool = false) async {
        // Load cached notifications from Core Data for instant display
        notifications = loadFromCache()

        if notifications.isEmpty || refetch {
            do {
                let lastFetchDate: Date? = UserDefaultsKeys.lastNotificationsFetchDate.getValue()
                let newNotifications = try await notificationClient.fetchNewAppNotifications(lastUpdated: lastFetchDate)
                saveToCache(newNotifications)
                UserDefaultsKeys.lastNotificationsFetchDate.setValue(Date.now)
                notifications = loadFromCache()
            }
            catch {
                Logger.general.error("Error fetching notifications: \(error.localizedDescription)")
            }
        }
    }

    func deleteNotification(withId notificationId: String) {
        Task {
            do {
                try await notificationClient.deleteNotification(notificationId)
                deleteFromCache(notificationId)
                notifications.removeAll { $0.id == notificationId }
            }
            catch {
                Logger.general.error("Error deleting notification \(notificationId): \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Core Data Helpers

    private func loadFromCache() -> [AppNotification] {
        let request = NSFetchRequest<CachedAppNotification>(entityName: "CachedAppNotification")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            let cached = try viewContext.fetch(request)
            return cached.compactMap { AppNotification.from($0) }
        }
        catch {
            Logger.general.error("Error loading notifications from cache: \(error.localizedDescription)")
            return []
        }
    }

    private func saveToCache(_ notifications: [AppNotification]) {
        for notification in notifications {
            let request = NSFetchRequest<CachedAppNotification>(entityName: "CachedAppNotification")
            request.predicate = NSPredicate(format: "id == %@", notification.id ?? "")
            request.fetchLimit = 1

            do {
                let existing = try viewContext.fetch(request).first
                let entity = existing ?? CachedAppNotification(context: viewContext)
                notification.populate(entity)
            }
            catch {
                Logger.general.error("Error upserting notification to cache: \(error.localizedDescription)")
            }
        }

        do {
            try viewContext.save()
        }
        catch {
            Logger.general.error("Error saving notification cache: \(error.localizedDescription)")
        }
    }

    private func deleteFromCache(_ notificationId: String) {
        let request = NSFetchRequest<CachedAppNotification>(entityName: "CachedAppNotification")
        request.predicate = NSPredicate(format: "id == %@", notificationId)
        request.fetchLimit = 1

        do {
            if let cached = try viewContext.fetch(request).first {
                viewContext.delete(cached)
                try viewContext.save()
            }
        }
        catch {
            Logger.general.error("Error deleting notification from cache: \(error.localizedDescription)")
        }
    }
}
