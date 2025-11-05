//
//  NFPRedeemViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/12/25.
//

import Foundation
import SwiftUI

enum RedeemView {
    
    case hasCredits
    case noCredits
    case codeScreen
    case redeemSuccess
    case venues
    case help
}

@Observable
class NFPRedeemViewModel {
    
    var displayView: RedeemView = .hasCredits
    var venueCode: String = ""
    var error: Error?
    var nfpVenues: [Account] = .init()
    var seeVenuesButtonIsVisible = true
    
    var nextCreditDate = NFPManager.shared.nextCreditDate
    
    var day: Int = 0
    var hour: Int = 0
    var minute: Int = 0
    var second: Int = 0
    
    var helpOptions: [NFPHelpOption] = [.FAQ, .Support, .Report, .Issue, .Feedback, .Locations]
    
    init() {
        displayView = mainDisplayView
        updateTimer()
    }
    
    func nfpButtonTapped() {
        withAnimation {
            displayView = .codeScreen
        }
    }
    
    func changeView(to view: RedeemView) {
        withAnimation {
            displayView = view
        }
    }
    
    var mainDisplayView: RedeemView {
        return NFPManager.shared.hasCredits ? .hasCredits : .noCredits
    }
    
    func redeemCredit() {
        Task {
            let redemptionResult = await NFPManager.shared.redeemCredit(code: venueCode)
            switch redemptionResult {
                
            case .success(_):
                changeView(to: .redeemSuccess)
            case .failure(let error):
                self.error = error
            }
            
        }
    }
    
    func updateTimer() {
        let calendar = Calendar(identifier: .gregorian)
        let timeValue = calendar.dateComponents([.day, .hour, .minute, .second], from: Date.now, to: nextCreditDate)
        
        self.day = timeValue.day ?? 0
        self.hour = timeValue.hour ?? 0
        self.minute = timeValue.minute ?? 0
        self.second = timeValue.second ?? 0
    }
    
    func fetchNFPVenues() async {
        nfpVenues = await AccountClient.fetchNightflyyPlusProviders().filter{$0.accountType == .venue}
    }
    
    func navigateToProfile(account: Account) {
        let viewModel = ProfileViewModel(account: account)
        Router.shared.navigateTo(.Profile(viewModel))
    }
    
}
