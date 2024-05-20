//
//  ChangePasswordView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/11/25.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @Environment(\.dismiss) var dismiss
    @Bindable var viewModel: ChangePasswordViewModel
    @Environment(ToastsManager.self) private var toastsManager
    
    var body: some View {
        @Bindable var toastsManager = toastsManager
        
        VStack(alignment: .leading) {
            CustomSecureTextField(placeholder: "Current Password", value: $viewModel.currentPassword)
            
            CustomSecureTextField(placeholder: "New Password", value: $viewModel.newPassword)
            
            CustomSecureTextField(placeholder: "Confirm New Password", value: $viewModel.confirmNewPassword)
            
            Button("Change Password") {
                viewModel.changePassword()
            }
            .mainButtonStyle()
            .padding(.top, 48)
            
            Spacer()
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
        .foregroundStyle(.white)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Change Password")
                    .foregroundStyle(.white)
            }
        }
        .errorAlert(error: $viewModel.error, buttonTitle: "OK")
        .interactiveToast($toastsManager.toasts)
    }
}

#Preview {
    ChangePasswordView(viewModel: ChangePasswordViewModel())
}
