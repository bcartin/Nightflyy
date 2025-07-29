//
//  SendObjectAsMessageView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/11/25.
//

import SwiftUI

struct SendObjectAsMessageView: View {
    
    @Bindable var viewModel: SendObjectAsMessageViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                RoundedRectangle(cornerRadius: 3)
                    .fill(.gray.opacity(0.9))
                    .frame(width: 86, height: 6)
                    .safeAreaPadding(.top, 12)
                    .padding(.bottom, 12)
                
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.followers, id: \.self) { followerId in
                            MultiSelectAccountListItemView(accountId: followerId, selectedAccounts: $viewModel.selectedAccounts)
                                .padding(.horizontal)
                        }
                        
                        Divider()
                    }
                }
                .scrollIndicators(.hidden)
            }
            
            if !viewModel.selectedAccounts.isEmpty {
                Button(viewModel.isEvent ? "Send Invite" : "Send") {
                    viewModel.sendMessages()
                }
                .mainButtonStyle()
            }
        }
        .frame(maxWidth: .infinity)
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
        .errorAlert(error: $viewModel.error, buttonTitle: "OK")
        .onChange(of: viewModel.shouldDismiss) { oldValue, newValue in
            dismiss()
        }
    }
}

#Preview {
    SendObjectAsMessageView(viewModel: SendObjectAsMessageViewModel())
}
