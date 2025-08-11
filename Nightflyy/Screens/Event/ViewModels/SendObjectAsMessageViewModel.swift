//
//  SendObjectAsMessageViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/11/25.
//

import Foundation
import SwiftUI

@Observable
class SendObjectAsMessageViewModel {
    
    var event: Event?
    var account: Account?
    var followers = AccountManager.shared.account?.followers ?? []
    var error: Error?
    var selectedAccounts: [String] = .init()
    var message: Message?
    var shouldDismiss: Bool = false
    var isEvent: Bool
    
    init(event: Event? = nil, account: Account? = nil) {
        self.event = event
        self.account = account
        self.isEvent = event != nil
        createMessage()
    }
    
    func createMessage() {
        self.message =  Message(sender: AccountManager.shared.account?.uid ?? "", recipient: "", date: Date(), type: messageType, messageData: getMessageData())
    }
    
    var messageType: MessageType {
        return isEvent ? .event : .account
    }

    
    func getMessageData() -> MessageData {
        if isEvent {
            return MessageData(event_name: event?.eventName, event_id: event?.uid, event_flyer_url: event?.eventFlyerUrl)
        }
        else {
            return MessageData(username: account?.username, uid: account?.uid, profile_image_url: account?.profileImageUrl)
        }
    }
    
    func sendMessages() {
        guard var message = message else {return}
        selectedAccounts.forEach { accountId in
            let chat = ChatsManager.shared.getChat(with: accountId)
            message.recipient = accountId
            do {
                try ChatsManager.sendMessage(chatId: chat.uid, message: message)
                shouldDismiss = true
                General.showSuccessMessage(message: "Message Sent", imageName: "checkmark.circle.fill")
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}
