//
//  EventCommentView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/26/25.
//

import SwiftUI

struct EventCommentView: View {
    
    var viewModel: EventCommentViewModel
    
    var body: some View {
        HStack(alignment: .top) {
            UserImageRound(imageUrl: viewModel.account?.profileImageUrl, size: 38)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(viewModel.account?.username ?? "")
                        .font(.system(size: 11))
                    
                    Text(viewModel.comment.date.timeAgo())
                        .font(.system(size: 11))
                        .foregroundStyle(.gray)
                    
                    Spacer()
                }
                
                Text(viewModel.comment.comment)
                    .font(.system(size: 13))
            }
            .foregroundStyle(.white)
            
            Spacer()
            
            VStack(spacing: 4) {
                Button {
                    viewModel.likeComment()
                } label: {
                    Image(systemName: viewModel.haveLiked ? "heart.fill" : "heart")
                        .foregroundStyle(viewModel.haveLiked ? .mainPurple : .gray)
                }
                .padding(.top, 4)
                .disabled(viewModel.haveLiked)
                
                Text(viewModel.numberOfLikes)
                    .font(.system(size: 9))
                    .foregroundStyle(.gray)
            }

        }
        .padding(.horizontal)
    }
}
