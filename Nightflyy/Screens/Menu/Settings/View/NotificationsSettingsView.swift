//
//  NotificationsSettingsView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/11/25.
//

import SwiftUI

struct NotificationsSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(ToastsManager.self) private var toastsManager
    @Bindable var viewModel: NotificationsSettingsViewModel
    
    var body: some View {
        @Bindable var toastsManager = toastsManager
        
        NavigationStack {
            
            ZStack {
                VStack(spacing: 18) {
                    SwitchView(label: "Allow Push Notifications", value: $viewModel.allowPushNotificaitons)
                    
                    if viewModel.allowPushNotificaitons {
                        SwitchView(label: "Follow Started", value: $viewModel.followStarted)
                        
                        SwitchView(label: "Follow Request", value: $viewModel.followRequest)
                        
                        SwitchView(label: "Follow Request Accepted", value: $viewModel.followRequestAccepted)
                        
                        SwitchView(label: "Alerts", value: $viewModel.alert)
                        
                        SwitchView(label: "Direct Message", value: $viewModel.directMessage)
                        
                        SwitchView(label: "Event Invite", value: $viewModel.eventInvite)
                        
                        SwitchView(label: "Event RSVP'd", value: $viewModel.eventRsvp)
                        
                        SwitchView(label: "Chatroom Comments", value: $viewModel.chatroomComment)
                    }
                    
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .backgroundImage("slyde_background")
                    .background(.backgroundBlack)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                viewModel.saveChanges()
                            } label: {
                                Text("Save")
                                    .foregroundStyle(.white)
                            }
                        }
                        
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundStyle(.white)
                            }
                        }
                        
                        ToolbarItem(placement: .principal) {
                            Text("Push Notificaitons Settings")
                                .foregroundStyle(.white)
                        }
                    }
                    
                    if viewModel.isLoading {
                        LoadingView()
                    }
                
            }
            .errorAlert(error: $viewModel.error, buttonTitle: "OK")
        }
        .tint(.white)
        .interactiveToast($toastsManager.toasts)
    }
    
    @ViewBuilder
    private func SwitchView(label: String, value: Binding<Bool>) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.white)
            
            Spacer()
            
            Toggle(isOn: value, label: { })
                .tint(.mainPurple)
                .fixedSize()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)

    }
}

#Preview {
    NotificationsSettingsView(viewModel: NotificationsSettingsViewModel())
}
