//
//  NFPContainerView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/12/25.
//

import SwiftUI

struct NFPContainerView: View {
    
    @State var signUpViewModel: NFPSignUpViewModel = .init()
    @Environment(AppState.self) private var appState
    
    var body: some View {
        ZStack {
            if AccountManager.shared.isPlusMember {
                MemberView()
            }
            else {
                switch signUpViewModel.displayView {
                case .paywall:
                    PaywallView(viewModel: $signUpViewModel)
                case .promoCode:
                    PromoCodeView(viewModel: $signUpViewModel)
                        .transition(.opacity)
                case .venueSelection:
                    VenueReferralView(viewModel: $signUpViewModel)
                        .transition(.opacity)
                case .confirm:
                    ConfirmNFPView(viewModel: $signUpViewModel)
                        .transition(.opacity)
                case .completed:
                    SignUpCompletedView(viewModel: $signUpViewModel)
                        .transition(.opacity)
                }
            }
            
            if appState.isLoading {
                LoadingView()
            }
        }
        .errorAlert(error: $signUpViewModel.error, buttonTitle: "OK")
    }
}

#Preview {
    NFPContainerView()
}
