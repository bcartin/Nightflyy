//
//  InviteToEventView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/11/25.
//

import SwiftUI

struct InviteFromEventView: View {
    
    @Bindable var viewModel: InviteFromEventViewModel
    
    var body: some View {
        VStack {
            
            RoundedRectangle(cornerRadius: 3)
                .fill(.gray.opacity(0.9))
                .frame(width: 86, height: 6)
                .safeAreaPadding(.top, 12)
                .padding(.bottom, 12)
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.followers, id: \.self) { followerId in
                        AccountRowWithAction(accountId: followerId,
                                             actionName: viewModel.label(for: followerId),
                                             buttonStyle: viewModel.style(for: followerId),
                                             isDisabled: viewModel.isDisabled(for: followerId),
                                             action: {
                            viewModel.inviteToEvent(accountId: followerId)
                        })
                        .padding(.horizontal)
                    }
                    Divider()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
        .scrollIndicators(.hidden)
        .errorAlert(error: $viewModel.error, buttonTitle: "OK")
    }
}

#Preview {
    InviteFromEventView(viewModel: InviteFromEventViewModel(event: Event()))
}
