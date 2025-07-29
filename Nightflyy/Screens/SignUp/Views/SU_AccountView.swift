//
//  SU_AccountView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/21/25.
//

import SwiftUI

struct SU_AccountView: View {
    
    @Binding var viewModel: SignupViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            
            Text("Account")
                .font(.system(size: 17, weight: .bold))
            
            CustomTextField(placeholder: "Email", value: $viewModel.email, isRequired: true)
            
            CustomSecureTextField(placeholder: "Password", value: $viewModel.password, isRequired: true)
            
            CustomSecureTextField(placeholder: "Confirm Password", value: $viewModel.confirmPassword, isRequired: true)
            
            Spacer()
            
            Button("Next") {
                viewModel.validateAccountFields()
            }
            .mainButtonStyle()
        }
        .errorAlert(error: $viewModel.error, buttonTitle: "OK")
        .ignoresSafeArea()
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.white)
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
    }
}

#Preview {
    SU_AccountView(viewModel: .constant(SignupViewModel()))
}
