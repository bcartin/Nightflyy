//
//  Navigator.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/18/25.
//

import Foundation

class Navigator {
    
    var router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func handleUniversalLink(url: URL) {
        Task {
            let link = UniversalLink(url: url)
            let id = link.objectId
            switch link.type {
            case .event:
                guard let id = id else {return}
                await navigateToEvent(eventId: id)
            case .venue:
                guard let id = id else {return}
                await navigateToAccount(accountId: id)
            case .person:
                guard let id = id else {return}
                await navigateToAccount(accountId: id)
            case .nfplus:
                UserDefaultsKeys.nfpReferred.setValue(id)
                await openNFPpaywall(accountId: id)
            case .chat:
                print("chat")
            case .other:
                print("other")
            }
        }
    }
    
//    func handleDeepLink(url: URL) {
//        Task {
//            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
//            if let accountId = components?.queryItems?.first(where: {$0.name == "id"})?.value {
//                UserDefaultsKeys.nfpReferred.setValue(accountId)
//                await openNFPpaywall(accountId: accountId)
//            }
//        }
//    }
    
    func handlePushNotification(userInfo: [AnyHashable:Any]) {
        Task {
            guard let typeString = userInfo["type"] as? String else { return }
            let type = UniversalLinkType(rawValue: typeString)
            let id = userInfo["id"] as? String
            switch type {
            case .event:
                guard let id = id else {return}
                await navigateToEvent(eventId: id)
            case .venue:
                guard let id = id else {return}
                await navigateToAccount(accountId: id)
            case .person:
                guard let id = id else {return}
                await navigateToAccount(accountId: id)
            case .nfplus:
                await openNFPpaywall(accountId: id)
            case .chat:
                print("chat")
            case .other:
                print("other")
            case .none:
                print("none")
            }
        }
    }
    
    private func navigateToEvent(eventId: String) async {
        guard AuthenticationManager.shared.isSignedIn else {return}
        guard let event = await EventClient.fetchEvent(eventId: eventId) else {return}
        let viewModel = EventViewModel(event: event)
        router.navigateTo(.Event(viewModel))
    }
    
    private func navigateToAccount(accountId: String) async {
        guard AuthenticationManager.shared.isSignedIn else {return}
        guard let account = await AccountClient.fetchAccount(accountId: accountId) else {return}
        let viewModel = ProfileViewModel(account: account)
        router.navigateTo(.Profile(viewModel))
    }
    
    private func openNFPpaywall(accountId: String?) async {
        if let accountId = accountId {
            if let account = await AccountClient.fetchAccount(accountId: accountId) {
                NFPManager.shared.referralAccount = account
            }
        }
        guard AuthenticationManager.shared.isSignedIn else {return}
        NFPManager.shared.showNFPView = true
    }
    
    private func navigateToChat(chatId: String) async {
        AppState.shared.selectedTab = 4
        if let viewModel = ChatsManager.shared.viewModels.first(where: {$0.chatID == chatId}) {
            router.navigateTo(.ChatView(viewModel))
        }
    }
    
}
