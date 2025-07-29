//
//  InboxViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/24/24.
//

import SwiftUI

@Observable
class InboxViewModel {
    
    var shouldPresentNewChatView: Bool = false
    var searchText: String = ""
    
    var viewModels: [InboxRowViewModel] {
        if searchText.isEmpty {
            return ChatsManager.shared.viewModels
        }
        else {
            return ChatsManager.shared.viewModels.filter{$0.account?.username?.contains(searchText) ?? false}
        }
    }
    
    func markAsRead(viewModel: InboxRowViewModel) {
        var chat = viewModel.chat
        if chat.lastMessageSender != AccountManager.shared.account?.uid {
            chat.isNew = false
            try? chat.save()
        }
    }
    
    func navigateToChat(viewModel: InboxRowViewModel) {
        markAsRead(viewModel: viewModel)
        Router.shared.navigateTo(.ChatView(viewModel))
    }
    
}
