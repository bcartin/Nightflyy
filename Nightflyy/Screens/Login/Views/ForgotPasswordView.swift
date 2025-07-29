//
//  ForgotPasswordView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/19/25.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @Binding var viewModel: LoginViewModel
    @Binding var signUpViewModel: SignupViewModel
    
    var body: some View {
        VStack {
            Text("Please enter your email address and we will send you a link to reset your password")
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(24)
            
            CustomTextField(placeholder: "Email", value: $viewModel.email)
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .padding(.bottom, 36)
            
            Button("Send") {
                viewModel.handleForgotPassword()
            }.mainButtonStyle()
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
        .errorAlert(error: $viewModel.error)
        .alert(isPresented: $viewModel.presentEmailSentAlert) {
            CustomDialog(title: "Email Sent", content: "Please check your email to continue",
                         button1: .init(content: "OK", tint: .mainPurple, foreground: .white, action: { folder in
                viewModel.presentEmailSentAlert = false
                signUpViewModel.navigationPath.removeLast()
            }))
            .transition(.blurReplace.combined(with: .push(from: .bottom)))
        } background: {
            Rectangle()
                .fill(.primary.opacity(0.35))
        }
    }
}

#Preview {
    ForgotPasswordView(viewModel: .constant(LoginViewModel()), signUpViewModel: .constant(SignupViewModel()))
}
