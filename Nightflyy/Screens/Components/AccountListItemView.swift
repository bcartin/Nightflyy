//
//  AccountListItemView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/14/25.
//

import SwiftUI

struct AccountListItemView: View {
    
    var accountId: String
    @State var account: Account?
    var onTapAction: ButtonAction
    
    var body: some View {
        HStack(spacing: 12) {
            UserImageRound(imageUrl: account?.profileImageUrl, size: 48)
            
            Text(account?.username ?? "")
                .foregroundStyle(.white)
                .fontWeight(.medium)
            
            Spacer()
        }
        .padding(8)
        .task {
            account = await AccountClient.fetchAccount(accountId: accountId)
        }
        .onTapGesture {
            onTapAction()
        }
    }
    
}
