//
//  SignedOutView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/14/25.
//

import SwiftUI

struct SignedOutView: View {
    
    @State var loginViewModel = LoginViewModel()
    @State var viewModel: SignupViewModel = .init()
    @State var flip = true
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ZStack {
                SignUpView(flip: $flip, viewModel: $viewModel)
                    .padding(.vertical, 48)
                    .opacity(flip ? 1 : 0)
                    .rotation3DEffect(.degrees(flip ? 0: -89.9), axis: (x: 0, y: 1, z: 0))
                    .animation(flip ? .linear.delay(0.35) : .linear, value: flip)
                
                LoginView(viewModel: loginViewModel, signUpViewModel: $viewModel, flip: $flip)
                    .opacity(flip ? 0 : 1)
                    .rotation3DEffect(.degrees(flip ? 89.9 : 0), axis: (x: 0, y: 1, z: 0))
                    .animation(flip ? .linear : .linear.delay(0.35), value: flip)
            }
            .edgesIgnoringSafeArea(.all)
            .background(.backgroundBlack)
            .navigationDestination(for: SignupScreen.self) { selection in
                switch selection {
                case .account:
                    SU_AccountView(viewModel: $viewModel)
                case .profile:
                    SU_ProfileView(viewModel: $viewModel)
                case .location:
                    SU_LocationView(viewModel: $viewModel)
                case .paywall:
                    SU_Paywall(viewModel: $viewModel)
                case .gender:
                    ListSelectView(title: "Gender", listItems: Gender.allCases.map(\.rawValue), selectedItem: $viewModel.gender)
                case .dob:
                    DateSelectView(title: "Date of Birth", selectedDate: $viewModel.convertedDob)
                case .forgotPassword:
                    ForgotPasswordView(viewModel: $loginViewModel, signUpViewModel: $viewModel)
                }
            }
            
        }
        .tint(.white)
    }
}

#Preview {
    SignedOutView()
}
