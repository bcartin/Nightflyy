//
//  MessageViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 1/30/25.
//

import Foundation
import SwiftUI

@Observable
class MessageViewModel: Identifiable {

    var message: Message

    init(message: Message) {
        self.message = message
    }

    var id: String {
        "\(message.id ?? "")"
    }

    var isSender: Bool {
        AccountManager.shared.account?.id == message.sender
    }

    var messageImageUrl: String? {
        switch message.type {
        case .text:
            return nil
        case .account:
            return message.messageData.profileImageUrl
        case .event:
            return message.messageData.eventFlyerUrl

        }
    }

    var messageText: String {
        switch message.type {
        case .text:
            return message.messageData.message ?? ""
        case .account:
            return message.messageData.username ?? ""
        case .event:
            return message.messageData.eventName ?? ""

        }
    }

    var imagePlaceholder: String {
        switch message.type {
        case .text:
            return ""
        case .account:
            return "person.circle.fill"
        case .event:
            return "questionmark.square.dashed"
        }
    }

    func navigateTo() {
        switch message.type {
        case .text:
            return
        case .account:
            navigateToAccount()
        case .event:
            navigateToEvent()
        }
    }

    private func navigateToAccount() {
        Task {
            guard let uid = message.messageData.uid else {
                await Router.shared.navigateTo(.notFound(.profile))
                return
            }
            let account = await AccountClient.fetchAccount(accountId: uid)
            await Router.shared.navigateToProfile(account: account)
        }
    }

    private func navigateToEvent() {
        Task {
            guard let eventId = message.messageData.eventId else {
                await Router.shared.navigateTo(.notFound(.event))
                return
            }
            let event = await EventClient.fetchEvent(eventId: eventId)
            await Router.shared.navigateToEvent(event: event)
        }
    }

}
