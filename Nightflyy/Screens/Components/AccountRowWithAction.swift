//
//  AccountRowWithAction.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/10/25.
//

import SwiftUI

struct AccountRowWithAction: View {
    
    var accountId: String
    @State var account: Account?
    var actionName: String
    var buttonStyle: ActionButtonStyle
    var isDisabled: Bool
    var action: ButtonAction
    
    var body: some View {
        HStack(spacing: 12) {
            UserImageRound(imageUrl: account?.profileImageUrl, size: 48)
            
            Text(account?.username ?? "")
                .foregroundStyle(.white)
                .fontWeight(.medium)
            
            Spacer()
            
            Button(actionName) {
                action()
            }
            .disabled(isDisabled)
            .buttonStyle(
                buttonStyle == .actionPrimary ? .actionPrimary : .actionSecondary
            )
        }
        .task {
            account = await AccountClient.fetchAccount(accountId: accountId)
        }
    }
}

#Preview {
    AccountRowWithAction(accountId: "", account: Account(profileImageUrl: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8dXNlcnxlbnwwfHwwfHx8MA%3D%3D", username: "Panchita"), actionName: "Invite", buttonStyle: .actionPrimary, isDisabled: false, action: {})
        .preferredColorScheme(.dark)
}
