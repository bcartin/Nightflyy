//
//  NewChatView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/14/25.
//

import SwiftUI

struct NewChatView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var viewModel: NewChatViewModel
    
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
                            AccountListItemView(accountId: followerId) {
                                viewModel.navigateToChat(with: followerId)
                            }
                            .padding(.horizontal)
                        }
                        
                        Divider()
                    }
                }
                .scrollIndicators(.hidden)
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
