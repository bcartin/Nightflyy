//
//  PrivacySettingsView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/11/25.
//

import SwiftUI

struct PrivacySettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(ToastsManager.self) private var toastsManager
    @Bindable var viewModel: PrivacySettingsViewModel
    
    var body: some View {
        @Bindable var toastsManager = toastsManager
        
        NavigationStack {
            
            ZStack {
                VStack(spacing: 18) {
                    HStack {
                        
                        Text("Private Account")
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        Toggle(isOn: $viewModel.isPrivateAccount, label: { })
                            .tint(.mainPurple)
                            .fixedSize()
                    }
                    .padding(.horizontal)
                    
                    Text("Only followers that you approve will be able to view your account content when your account is private.")
                        .foregroundStyle(.gray)
                        .font(.caption)
                    
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .backgroundImage("slyde_background")
                .background(.backgroundBlack)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            viewModel.saveChanges()
                        } label: {
                            Text("Save")
                                .foregroundStyle(.white)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.white)
                        }
                    }
                    
                    ToolbarItem(placement: .principal) {
                        Text("Privacy Settings")
                            .foregroundStyle(.white)
                    }
                }
                
                if viewModel.isLoading {
                    LoadingView()
                }
                
            }
            .errorAlert(error: $viewModel.error, buttonTitle: "OK")
        }
        .tint(.white)
        .interactiveToast($toastsManager.toasts)
    }
}

#Preview {
    PrivacySettingsView(viewModel: PrivacySettingsViewModel())
}
