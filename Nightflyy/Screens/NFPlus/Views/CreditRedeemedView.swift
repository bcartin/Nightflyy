//
//  CreditRedeemedView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/12/25.
//

import SwiftUI

/// Confirmation shown after a perk is redeemed, with options to share it or finish.
struct CreditRedeemedView: View {

    @Environment(\.dismiss) var dismiss
    @Binding var viewModel: NFPRedeemViewModel

    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            Image("ConfirmationCheck")
                .resizable()
                .frame(width: 120, height: 120)
                .padding(.bottom)

            VStack(spacing: 4) {
                Text("Credit Redeemed")
                    .font(.footnote)
                    .bold()

                Text("Enjoy your perk!")
                    .font(.largeTitle)
                    .bold()
            }

            Spacer()

            // Verbatim so the asterisks show instead of being read as Markdown italics.
            Text(verbatim: "*Remember to tip your server generously*")
                .font(.caption)

            Button("Share") {
                viewModel.isSharingPerk = true
            }
            .mainButtonStyle()
            .disabled(viewModel.selectedPerk == nil)

            Button {
                dismiss()
            } label: {
                Text("Continue")
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
        .foregroundStyle(.white)
        .padding(.bottom)
        .sheet(isPresented: $viewModel.isSharingPerk) {
            if let perk = viewModel.selectedPerk {
                PerkShareView(perk: perk)
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

#Preview {
    MemberView()
}
