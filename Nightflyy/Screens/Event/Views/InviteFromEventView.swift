//
//  InviteToEventView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/11/25.
//

import SwiftUI

struct InviteFromEventView: View {
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(AccountManager.shared.account?.followers) { followerId in
                    
                }
            }
        }
        .frame(maxWidth: .infinity)
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    InviteFromEventView()
}
