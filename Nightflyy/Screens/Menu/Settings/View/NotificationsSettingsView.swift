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
    @Environment(PushNotificationsManager.self) private var pushNotificationsManager
    @Bindable var viewModel: NotificationsSettingsViewModel

    var body: some View {
        @Bindable var toastsManager = toastsManager

        NavigationStack {

            ZStack {
                VStack(spacing: 18) {
                    switchView(label: "Allow Push Notifications", value: $viewModel.allowPushNotificaitons)

                    if viewModel.allowPushNotificaitons {
                        switchView(label: "Follow Started", value: $viewModel.followStarted)

                        switchView(label: "Follow Request", value: $viewModel.followRequest)

                        switchView(label: "Follow Request Accepted", value: $viewModel.followRequestAccepted)

                        switchView(label: "Alerts", value: $viewModel.alert)

                        switchView(label: "Direct Message", value: $viewModel.directMessage)

                        switchView(label: "Event Invite", value: $viewModel.eventInvite)

                        switchView(label: "Event RSVP'd", value: $viewModel.eventRsvp)

                        switchView(label: "Chatroom Comments", value: $viewModel.chatroomComment)
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
            .alert("Change in Settings", isPresented: $viewModel.showSettingsAlert) {
                Button("Not Now", role: .cancel) { }
                Button("Open Settings") {
                    viewModel.openAppSettings()
                }
            } message: {
                Text("You can turn push notifications on or off from the iOS Settings app.")
            }
        }
        .tint(.white)
        .interactiveToast($toastsManager.toasts)
        .task {
            await pushNotificationsManager.refreshAuthorizationStatus()
        }
    }

    @ViewBuilder
    private func switchView(label: String, value: Binding<Bool>) -> some View {
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
