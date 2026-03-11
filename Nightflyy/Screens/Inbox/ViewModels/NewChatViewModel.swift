//
//  NewChatViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/14/25.
//

import Foundation
import SwiftUI

@Observable @MainActor
class NewChatViewModel {
    
    var account: Account?
    var followers = AccountManager.shared.account?.followers ?? []
    var error: Error?
    var message: Message?
    var shouldDismiss: Bool = false
    
    init() {

    }
    
    func navigateToChat(with accountId: String) {
        do {
            let chat = try ChatsManager.shared.getChat(with: accountId)
            let viewModel = InboxRowViewModel(chat: chat)
            shouldDismiss = true
            Router.shared.navigateTo(.ChatView(viewModel))
        }
        catch {
            print(error.localizedDescription)
        }
        
    }
}
