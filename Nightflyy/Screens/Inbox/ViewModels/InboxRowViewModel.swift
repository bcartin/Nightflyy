//
//  InboxRowViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/25/24.
//

import Foundation
import SwiftUI
import CoreData
import OSLog

@Observable @MainActor
class InboxRowViewModel: Hashable, Identifiable {
    
    nonisolated let id: String
    
    nonisolated static func == (lhs: InboxRowViewModel, rhs: InboxRowViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var chat: Chat
    var account: Account?
    var defaultUserImage: UIImage = UIImage(systemName: "person.circle")!.withRenderingMode(.alwaysTemplate)
    var messages: [Message] = []
    var messagesFetched: Bool = false
    var messageText: String = ""
    var error: Error?
    var shouldScrollToBottom: Bool = false
    private let viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext

    init(chat: Chat) {
        self.id = chat.id ?? UUID().uuidString
        self.chat = chat
        self.fetchAccount()
        print(chat.id!)
    }
    
    var chatID: String {
        "\(chat.id ?? "")"
    }
    
    var userName: String {
        account?.username ?? ""
    }
    
    var profileImageUrl: String {
        account?.profileImageUrl ?? ""
    }
    
    var lastUpdated: Date {
        chat.lastUpdated ?? .init()
    }
    
    var shouldHighlight: Bool {
        (chat.isNew ?? true) && chat.lastMessageSender == account?.uid
    }
    
    func fetchAccount() {
        Task {
            guard let accountID = chat.members.first(where: { uid in
                return uid != AccountManager.shared.account?.uid ?? ""
            }) else { return }
            
            account = await AccountClient.fetchAccount(accountId: accountID)
        }
    }
    
    func goToProfile() {
        guard let account else { return }
        let viewModel = ProfileViewModel(account: account)
        Router.shared.navigateTo(.Profile(viewModel))
    }
    
    func fetchMessages() async {
        if !messagesFetched {
            messagesFetched = true
            guard let chatId = chat.id else { return }

            // Load cached messages for instant display
            messages = loadMessagesFromCache(chatId: chatId)
            if !messages.isEmpty {
                shouldScrollToBottom = true
            }

            // Start listener for new messages only
            let latestDate = messages.last?.date
            ChatsManager.shared.createMessagesListener(uid: chatId, sinceDate: latestDate) { [weak self] newMessages in
                guard let self else { return }
                self.saveMessagesToCache(newMessages, chatId: chatId)
                self.messages.append(contentsOf: newMessages)
                self.shouldScrollToBottom = true
            }
        }
    }

    func stopListeners() {
        ChatsManager.shared.stopMessagesListener()
    }

    // MARK: - Core Data Helpers

    private func loadMessagesFromCache(chatId: String) -> [Message] {
        let request = NSFetchRequest<CachedMessage>(entityName: "CachedMessage")
        request.predicate = NSPredicate(format: "chatId == %@", chatId)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        do {
            let cached = try viewContext.fetch(request)
            return cached.compactMap { Message.from($0) }
        }
        catch {
            Logger.general.error("Error loading messages from cache: \(error.localizedDescription)")
            return []
        }
    }

    private func saveMessagesToCache(_ messages: [Message], chatId: String) {
        for message in messages {
            let request = NSFetchRequest<CachedMessage>(entityName: "CachedMessage")
            request.predicate = NSPredicate(format: "id == %@", message.id ?? "")
            request.fetchLimit = 1
            do {
                let existing = try viewContext.fetch(request).first
                let entity = existing ?? CachedMessage(context: viewContext)
                message.populate(entity)
                entity.chatId = chatId
            }
            catch {
                Logger.general.error("Error upserting message to cache: \(error.localizedDescription)")
            }
        }
        do {
            try viewContext.save()
        }
        catch {
            Logger.general.error("Error saving message cache: \(error.localizedDescription)")
        }
    }
    
    func sendMessage() {
        guard let sender = AccountManager.shared.account?.uid else { return }
        guard let recipient = account?.uid else { return }
        do {
            let message = Message(sender: sender, recipient: recipient, date: Date(), type: .text, messageData: MessageData(message: messageText))
            if chat.lastUpdated == nil {
                try ChatsManager.updateChat(&chat, with: message) //MARK: Create new chat if it doesn't exist.
            }
            try ChatsManager.sendMessage(chatId: chat.uid, message: message)
            self.messageText = ""
            self.shouldScrollToBottom = true
        }
        catch {
            self.error = error
        }
    }
    
    func deleteChat() {
        Task {
            do {
                try await ChatsManager.deleteChat(chatId: chatID)
                ChatsManager.shared.removeChat(chatId: chatID)
            }
            catch {
                self.error = error
            }
        }
    }
}
