//
//  SendObjectAsMessageView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/11/25.
//

import SwiftUI

struct SendObjectAsMessageView: View {
    
    @Bindable var viewModel: SendObjectAsMessageViewModel
    @FocusState private var isKeyboardActive: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                if #available(iOS 26.0, *) { // TODO: Remove when min version is iOS 26
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.callout)
                            .foregroundStyle(.white.opacity(0.5))
                        
                        TextField("", text: $viewModel.searchText, prompt: Text("Search").foregroundStyle(.white.opacity(0.5)))
                            .submitLabel(.search)
                            .focused($isKeyboardActive)
                        
                        if !viewModel.searchText.isEmpty {
                            Button {
                                viewModel.searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.callout)
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 44)
                    .glassEffect(.regular, in: .capsule)
                    .padding(.top, 8)
                    .padding(.horizontal, 16)
                }
                else {
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.callout)
                            .foregroundStyle(.white.opacity(0.5))
                        
                        TextField("", text: $viewModel.searchText, prompt: Text("Search").foregroundStyle(.white.opacity(0.5)))
                            .submitLabel(.search)
                            .focused($isKeyboardActive)
                        
                        if !viewModel.searchText.isEmpty {
                            Button {
                                viewModel.searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.callout)
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 40)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.top, 8)
                    .padding(.horizontal, 16)
                    
                }
                
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
    }
}

#Preview {
    SendObjectAsMessageView(viewModel: SendObjectAsMessageViewModel())
}
