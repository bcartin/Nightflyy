//
//  ChatView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/25/24.
//

import SwiftUI

struct ChatView: View {
    
    @Bindable var viewModel: InboxRowViewModel
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                ScrollViewReader { proxy in
                    ForEach(viewModel.messages) { message in
                        MessageView(viewModel: .init(message: message))
                            .padding(.horizontal, 12)
                    }
                    
                    HStack { Spacer() }
                        .id("Bottom")
                        .onReceive(keyboardPublisher) { value in
                            viewModel.shouldScrollToBottom = value
                        }
                        .onChange(of: viewModel.shouldScrollToBottom) { _, newValue in
                            if newValue {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    proxy.scrollTo("Bottom", anchor: .bottom)
                                    viewModel.shouldScrollToBottom = false
                                }
                            }
                        }
                }
            }
            .scrollDismissesKeyboard(.interactively)
            
            HStack(alignment: .top) {
                TextField("Message", text: $viewModel.messageText, axis: .vertical)
                    .padding()
                    .multilineTextAlignment(.leading)
                
                Button(action: {
                    viewModel.sendMessage()
                }, label: {
                    Image("ic_send")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.mainPurple)
                        .padding(.trailing)
                        .padding(.vertical)
                })
            }
            .frame(minHeight: 44)
            .background(.backgroundBlack)
        }
        .safeAreaInset(edge: .top) {
            CustomHeaderView()
        }
        .backgroundImage("slyde_background")
        .hideNavbarBackground()
        .task {
            await viewModel.fetchMessages()
        }
        .onAppear {
            viewModel.shouldScrollToBottom = true
        }
        .onDisappear {
            viewModel.stopListeners()
        }
        .errorAlert(error: $viewModel.error, buttonTitle: "OK")
    }
    
    @ViewBuilder
    func CustomHeaderView() -> some View {
        VStack(spacing: 6) {
            ZStack {
                UserImageRound(imageUrl: viewModel.profileImageUrl, size: 45)
            }
            .frame(width: 50, height: 50)
            
            Button {
                viewModel.goToProfile()
            } label: {
                HStack(spacing: 2) {
                    Text(viewModel.userName )
                    
                    Image(systemName: "chevron.right")
                        .font(.caption2)
                }
                .font(.caption)
                .foregroundStyle(.white)
                .contentShape(.rect)
            }

        }
        .frame(maxWidth: .infinity)
        .padding(.top, -25)
        .padding(.bottom, 15)
        .background {
            Rectangle()
                .fill(.backgroundBlack)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    InboxView(showMenu: .constant(false), viewModel: InboxViewModel())
        .preferredColorScheme(.dark)
}


