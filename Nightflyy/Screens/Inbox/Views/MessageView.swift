//
//  MessageView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 1/30/25.
//

import SwiftUI

struct MessageView: View {
    
    var viewModel: MessageViewModel
    
    var body: some View {
        switch viewModel.message.type {
        case .text:
            TextMessageView()
        case .account, .event:
            ImageMessageView()
        }
    }
    
    @ViewBuilder
    func TextMessageView() -> some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(viewModel.isSender ? .mainPurple : .white)
                .frame(width: 20, height: 20, alignment: viewModel.isSender ? .trailing : .leading)
                .frame(maxWidth: .infinity, alignment: viewModel.isSender ? .trailing : .leading)
            
            Text(viewModel.messageText)
                .padding(10)
                .foregroundStyle(viewModel.isSender ? .white : .black)
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(viewModel.isSender ? .mainPurple : .white)
                }
                .frame(maxWidth: 300, alignment: viewModel.isSender ? .trailing : .leading)
                .frame(maxWidth: .infinity, alignment: viewModel.isSender ? .trailing : .leading)
        }
    }
    
    @ViewBuilder
    func ImageMessageView() -> some View {
        ZStack(alignment: .bottom) {
            CustomImage(imageUrl: viewModel.messageImageUrl, size: .init(width: 150, height: 150), placeholder: viewModel.imagePlaceholder)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(viewModel.isSender ? .mainPurple : .white, lineWidth: 1)
                }
                .cornerRadius(15, corners: .allCorners)
               
            Text(viewModel.messageText)
                .foregroundStyle(viewModel.isSender ? .white : .black)
                .font(.system(size: 13, weight: .semibold))
                .frame(maxWidth: 150, alignment: .center)
                .padding(.vertical, 8)
                .background(viewModel.isSender ? .mainPurple : .white)
                .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
        }
        .frame(maxWidth: .infinity, alignment: viewModel.isSender ? .trailing : .leading)
        .onTapGesture {
            viewModel.navigateTo()
        }
    }
}

#Preview {
    MessageView(viewModel: MessageViewModel(message: Message(sender: "",
                                                             recipient: "",
                                                             type: .text,
                                                             messageData: MessageData())))
}
