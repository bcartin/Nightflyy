//
//  RedeemButtonView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/12/25.
//

import SwiftUI

/// Tells the member to hand their phone to the server before the staff code screen.
/// Members can turn it off with Never Show Again.
struct RedeemButtonView: View {

    @Binding var viewModel: NFPRedeemViewModel

    var body: some View {
        VStack(spacing: 16) {
            Text("Show phone to your server")
                .font(.title3)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.top, 64)

            AnimatedGIFView(assetName: "rotate")
                .frame(maxHeight: .infinity)
                .padding(.vertical)
                .accessibilityHidden(true)

            Button("Continue", action: viewModel.continueToCode)
                .mainButtonStyle()

            Button(action: viewModel.hideShowPhoneScreen) {
                Text("Never Show Again")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .contentShape(.capsule)
                    .overlay {
                        Capsule()
                            .stroke(.mainPurple, lineWidth: 1)
                    }
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 32)
        }
        .padding(.bottom)
    }
}

#Preview {
    MemberView()
}
