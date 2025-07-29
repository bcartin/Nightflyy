//
//  InboxRowView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/25/24.
//

import SwiftUI

struct InboxRowView: View {
    
    var viewModel: InboxRowViewModel
    var onClick: () -> ()
    @State private var viewRect: CGRect = .zero
    
    var body: some View {
        Button {
            onClick()
        } label: {
            HStack(spacing: 12) {
                UserImageRound(imageUrl: viewModel.profileImageUrl, size: 45)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(viewModel.userName)
                            .font(.callout)
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        Text(viewModel.lastUpdated.timeAgo())
                            .font(.caption2)
                            .foregroundStyle(.gray)
                    }
                    
                    Text(viewModel.chat.lastMessage ?? "")
                        .font(.caption2)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .fontWeight(viewModel.shouldHighlight ? .bold : .regular)
                        .foregroundStyle(viewModel.shouldHighlight ? .white : .gray)
                }
                
                Spacer(minLength: 0)
                
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
            .contentShape(.rect)
            
        }
        .listRowBackground(Color.backgroundBlack)

    }
}

#Preview {
    InboxView(showMenu: .constant(false), viewModel: InboxViewModel())
        .preferredColorScheme(.dark)
}
