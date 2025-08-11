//
//  NotificationsView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/1/25.
//

import SwiftUI

struct NotificationsView: View {
    
    @Binding var showMenu: Bool
    var viewModel: NotificationsViewModel
    
    var body: some View {
        RouterView {
            VStack(alignment: .leading) {
                if !(viewModel.hideSwipeForActionPrompt) {
                    HStack {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 16))
                            .foregroundStyle(.gray)
                        
                        Text("Swipe right for actions.")
                            .foregroundStyle(.gray)
                            .font(.system(size: 12))
                        
                        Button {
                            viewModel.setHideSwipeForActionPrompt(true)
                        } label: {
                            Text("Hide")
                                .font(.system(size: 12))
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .tint(Color.onlineBlue)

                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top)
                }
                
                List {
                    ForEach(AppNotificationsManager.shared.notifications) { notification in
                        let viewModel = NotificationViewModel(notification: notification)
                        NotificationView(viewModel: viewModel)
                            .listRowBackground(Color.clear)
                            .swipeActions {
                                viewModel.actionsView()
                            }
                    }
                    
                }
                .listStyle(PlainListStyle())
                .refreshable {
                    await AppNotificationsManager.shared.fetchNotifications(refetch: true)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .backgroundImage("slyde_background")
            .background(.backgroundBlack)
            .foregroundStyle(.white)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Notifications")
                        .foregroundStyle(.white)
                        .font(.system(size: 18, weight: .medium))
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        showMenu.toggle()
                    }, label: {
                        Image(systemName: showMenu ? "xmark" : "line.3.horizontal")
                            .foregroundStyle(.white)
                            .contentTransition(.symbolEffect)
                    })
                }
            }
            .task {
                await AppNotificationsManager.shared.fetchNotifications()
            }
        }
    }
}

