//
//  RedeemCodeView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/12/25.
//

import SwiftUI

/// Staff-facing screen: the member hands over their phone, and staff enter the venue code and swipe to redeem.
struct RedeemCodeView: View {

    @FocusState private var isFocused: Bool
    @ScaledMetric(relativeTo: .largeTitle) private var codeFontSize: CGFloat = 72
    @Binding var viewModel: NFPRedeemViewModel

    var body: some View {
        // The actions sit below the scrolling instructions so they stay on screen on any phone size.
        VStack(spacing: 16) {
            ScrollView(.vertical) {
                if let perk = viewModel.selectedPerk {
                    VStack(spacing: 24) {
                        PerkImage(imageUrl: perk.imageUrl, size: 110)
                            .clipShape(.circle)
                            .padding(.top, 48)

                        Text("Instructions for\n\(perk.venueName) Staff (ONLY)")
                            .font(.title2)
                            .bold()
                            .multilineTextAlignment(.center)

                        VStack(spacing: 24) {
                            RedeemInstructionSection(number: 1, title: "Provide Nightflyy Plus Member with:") {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("\(Text(perk.perkName).foregroundStyle(.onlineBlue)) at \(Text(perk.venueName))")
                                        .bold()

                                    Text("Note: This can only be done once per redemption.")
                                        .font(.caption2)
                                        .foregroundStyle(.gray)
                                }
                            }

                            RedeemInstructionSection(number: 2, title: "How to Redeem") {
                                VStack {
                                    Text("""
                                        Enter your 4 digit venue code below and swipe to redeem. Next, provide the above perk. \
                                        Once redeemed, it can not be used again until the following Monday.
                                        """)
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    TextField("", text: $viewModel.venueCode, prompt: Text("0000").foregroundStyle(.white.opacity(0.15)))
                                        .font(.system(size: codeFontSize, weight: .light))
                                        .tracking(24)
                                        .foregroundStyle(.white.opacity(0.6))
                                        .multilineTextAlignment(.center)
                                        .keyboardType(.numberPad)
                                        .focused($isFocused)
                                        .padding(.vertical, 8)
                                        .overlay(alignment: .bottom) {
                                            Rectangle()
                                                .fill(.mainPurple)
                                                .frame(height: 1)
                                        }
                                }
                            }

                            RedeemInstructionSection(number: 3, title: "How to Checkout") {
                                Text("In your POS, add the perk items to the check and apply the \"Nightflyy\" discount to the final bill.")
                            }
                        }
                        .padding()
                        .padding(.vertical)
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.gray.opacity(0.5), lineWidth: 1)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)

            let config = SlideToConfirm.Config(
                idleText: "Swipe to redeem",
                onSwipeText: "Redeeming...",
                confirmationText: "Redeemed!",
                tint: .mainPurple,
                foregorundColor: .white,
                knobColor: .mainPurple,
                knobIconColor: .white
            )

            SlideToConfirm(config: config) {
                viewModel.redeemCredit()
            }
            // A new id after a failed attempt resets the control so staff can swipe again.
            .id(viewModel.redeemAttempts)
            .disabled(viewModel.venueCode.isEmpty)
            .opacity(viewModel.venueCode.isEmpty ? 0.5 : 1)

            Button("Cancel", action: viewModel.cancelRedemption)
                .foregroundStyle(.mainPurple)
        }
        .onChange(of: viewModel.venueCode) { _, code in
            // Venue codes are 4 digits, so put the keyboard away once one is entered.
            if code.count >= 4 {
                isFocused = false
            }
        }
    }
}

#Preview {
    MemberView()
}
