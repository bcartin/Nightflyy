//
//  SendObjectAsMessageViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/11/25.
//

import Foundation
import SwiftUI
import Combine

@Observable
class SendObjectAsMessageViewModel: NSObject {
    
    var event: Event?
    var account: Account?
    var followers = AccountManager.shared.account?.followers ?? []
    var error: Error?
    var selectedAccounts: [String] = .init()
    var message: Message?
    var shouldDismiss: Bool = false
    var isEvent: Bool
    
    @ObservationIgnored
    @Published var searchText: String = ""
    private var searchCancellable: AnyCancellable?
    
    init(event: Event? = nil, account: Account? = nil) {
        self.event = event
        self.account = account
        self.isEvent = event != nil
        super.init()
        createMessage()
        
        searchCancellable = $searchText
            .receive(on: DispatchQueue.main)
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] fragment in
                self?.performSearch(searchText: fragment)
            })
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
    
    private func performSearch(searchText: String) {
        if searchText.isEmpty {
            self.followers = AccountManager.shared.account?.followers ?? []
        }
        else {
            let algoliaSearchResults = SearchManager.shared.performSearch(searchText: searchText).compactMap(\.objectID)
            let searchfollowers = AccountManager.shared.account?.followers ?? []
            self.followers = searchfollowers.filter {
                algoliaSearchResults.contains($0)
            }
        }
    }
}
