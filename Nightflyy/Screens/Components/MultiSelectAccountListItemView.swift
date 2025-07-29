//
//  AccountListItemView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/11/25.
//

import SwiftUI

struct MultiSelectAccountListItemView: View {
    
    var accountId: String
    @State var account: Account?
    @State var isSelected: Bool = false
    @Binding var selectedAccounts: [String]
    
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
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? .mainPurple : .backgroundBlackLight.opacity(0.4))
        )
        .onTapGesture {
            selectOrUnselect()
        }
    }
    
    func selectOrUnselect() {
        if let index = selectedAccounts.firstIndex(of: accountId) {
            selectedAccounts.remove(at: index)
            isSelected = false
        }
        else {
            selectedAccounts.append(accountId)
            isSelected = true
        }
    }
}
