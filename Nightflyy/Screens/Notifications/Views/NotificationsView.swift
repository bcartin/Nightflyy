//
//  NotificationsView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/1/25.
//

import SwiftUI

struct NotificationsView: View {
    
    @Binding var showMenu: Bool
    
    var body: some View {
        RouterView {
            VStack(alignment: .leading) {
                
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
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
//                        viewModel.navigateToCreateNewEvent()
                    }, label: {
                        Image(systemName:"plus")
                            .foregroundStyle(.white)
                    })
                }
            }
            .task {
                let notifications = try? await AppNotificationClient.fetchNewAppNotifications()
                print(notifications?.count)
            }
        }
    }
}

