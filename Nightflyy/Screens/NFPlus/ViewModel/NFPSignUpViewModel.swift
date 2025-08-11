//
//  NFPSignUpViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/27/25.
//

import SwiftUI
import Combine

enum NFPSignUpScreen {
    
    case paywall
    case promoCode
    case venueSelection
    case confirm
    case completed
}

@Observable
class NFPSignUpViewModel {
 
    var displayView: NFPSignUpScreen = .paywall
    var promoCode: String = ""
    var codeIsValid: Bool = false
    var codeRedeemed: Bool = false
    var error: Error?
    var referralVenue: Account?
    var filteredNFPProviders: [Account] = .init()
    var nfpProviders: [Account] = .init()
    
    @ObservationIgnored
    @Published var venueSearchText: String = ""
    
    private var searchCancellable: AnyCancellable?
    
    var isSigningUp: Bool {
        AuthenticationManager.shared.isSigningUp
    }
    
    var promoCodeCased: String {
        get {
            return promoCode.uppercased()
        }
        set {
            promoCode = newValue.uppercased()
        }
    }
    
    init() {
        searchCancellable = $venueSearchText
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] fragment in
                if !fragment.isEmpty {
                    self?.performSearch(searchText: fragment)
                }
                else {
                    self?.filteredNFPProviders = self?.nfpProviders ?? []
                }
            })
    }
    
    func checkForReferral() {
        if let account = NFPManager.shared.referralAccount {
            referralVenue = account
            changeView(to: .confirm)
        }
        else if let accountId: String = UserDefaultsKeys.nfpReferred.getValue() {
            Task {
                if let account = await AccountClient.fetchAccount(accountId: accountId) {
                    referralVenue = account
                    changeView(to: .confirm)
                }
            }
        }
        else {
            changeView(to: .promoCode)
        }
    }
    
    func changeView(to view: NFPSignUpScreen) {
        withAnimation {
            displayView = view
        }
    }
    
    func showBorder(for account: Account) -> Bool {
        return referralVenue == account
    }
    
    func validatePromoCode() {
        Task {
            AppState.shared.isLoading = true
            codeIsValid = await PromoCodesClient.codeIsValid(code: promoCode)
            AppState.shared.isLoading = false
            if codeIsValid {
                codeRedeemed = true
            }
            else {
                error = NFPError.invalidCode
            }
        }
    }
    
    func fetchNFPVenues() async {
        AppState.shared.isLoading = true
        nfpProviders = await AccountClient.fetchNightflyyPlusProviders()
        filteredNFPProviders = nfpProviders
        AppState.shared.isLoading = false
    }
    
    private func performSearch(searchText: String) {
        self.filteredNFPProviders = nfpProviders.filter {
            $0.name?.lowercased().contains(venueSearchText.lowercased()) ?? false ||
            $0.username?.lowercased().contains(venueSearchText.lowercased()) ?? false
        }
    }
    
    func purchaseNightFlyyPlus() {
        Task {
            do {
                let result = try await IAPManager.shared.purchase(venue: referralVenue)
                if result {
                    try await NFPManager.shared.makePlusMember(promoCode: promoCode)
                    if let venue = referralVenue {
                        try await NFPInvitesClient.addInvite(to: venue.uid)
                    }
                    changeView(to: .completed)
                    print("Successfully purchased NightFlyy Plus")
                }
            }
            catch {
                print(error.localizedDescription)
                self.error = error
            }
        }
    }
    
    func restoreSubscriptionOrSkip() {
        if isSigningUp {
            changeView(to: .completed)
            return
        }
        Task {
            do {
                try await IAPManager.shared.restorePurchases()
                changeView(to: .completed)
                print("Successfully purchased NightFlyy Plus")
            }
            catch {
                print(error.localizedDescription)
                self.error = error
            }
        }
    }
    
    func finishSignUp() {
        AuthenticationManager.shared.isSigningUp = false
    }
}
