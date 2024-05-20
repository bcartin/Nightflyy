//
//  NFPContainerView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/12/25.
//

import SwiftUI

struct NFPContainerView: View {
    var body: some View {
        if AccountManager.shared.isPlusMember {
            MemberView()
        }
        else {
            PaywallView()
        }
    }
}

#Preview {
    NFPContainerView()
}
