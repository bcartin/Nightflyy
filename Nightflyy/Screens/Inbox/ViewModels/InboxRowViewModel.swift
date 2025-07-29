//
//  InboxRowViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/25/24.
//

import Foundation
import SwiftUI

@Observable
class InboxRowViewModel: NSObject, Identifiable {
    
    var chat: Chat
    var account: Account?
    var defaultUserImage: UIImage = UIImage(systemName: "person.circle")!.withRenderingMode(.alwaysTemplate)
    var messages: [Message] = []
    var messagesFetched: Bool = false
    var messageText: String = ""
    var error: Error?
    var shouldScrollToBottom: Bool = false
    
    init(chat: Chat) {
        self.chat = chat
        super.init()
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
            print("Fetching Messages")
            messages.removeAll()
            guard let chatId = chat.id else { return }
            ChatsManager.shared.createMessagesListener(uid: chatId) { [weak self] messages in
                self?.messages = messages
                self?.shouldScrollToBottom = true
            }
        }
    }
    
    func stopListeners() {
        print("Stop Listening!!!")
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
