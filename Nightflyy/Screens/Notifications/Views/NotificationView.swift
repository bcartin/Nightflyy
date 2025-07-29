//
//  NotificationView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/1/25.
//

import SwiftUI

struct NotificationView: View {
    
    var viewModel: NotificationViewModel
    
    var body: some View {
        VStack {
            HStack {
                if viewModel.hasUser {
                    UserImageRound(imageUrl: viewModel.userImageUrl, size: 44)
                        .onTapGesture {
                            viewModel.goToProfile()
                        }
                }
                else {
                    Image("slyde_fly")
                        .resizable()
                        .frame(width: 44, height: 44)
                }
                
                VStack(alignment: .leading) {
                    viewModel.buildMainLabel()
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)
                    Text(viewModel.timeReceived)
                        .foregroundStyle(.mainPurple)
                        .font(.system(size: 10))
                }
                
                Spacer()
                
                if viewModel.hasEvent {
                    CustomImage(imageUrl: viewModel.eventFlyerUrl, size: .init(width: 44, height: 44), placeholder: "questionmark.square.dashed")
                        .cornerRadius(8)
                        .onTapGesture {
                            viewModel.goToEvent()
                        }
                }
            }
        }
    }
}

#Preview {
    NotificationView(viewModel: NotificationViewModel(notification: AppNotification(sender: "", date: .init(), type: .follow_request, notificationData: NotificationData())) )
}
