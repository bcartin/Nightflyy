//
//  PerkRedemptionDetailsView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/5/26.
//

import SwiftUI

/// Redemption instructions and the "Use this Perk" button shown when a perk row is expanded.
struct PerkRedemptionDetailsView: View {

    let perk: NFPPerk
    let useAction: ButtonAction

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Redemption Instructions:")
                    .font(.caption)
                    .bold()

                VStack(alignment: .leading, spacing: 2) {
                    ForEach(perk.redemptionSteps.enumerated(), id: \.offset) { index, step in
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("\(index + 1).")
                            Text(step)
                        }
                    }
                }
                .font(.caption)
            }

            Button(action: useAction) {
                Text("Use this Perk")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
            .tint(.mainPurple)
            .shadow(color: .mainPurple.opacity(0.6), radius: 10)
        }
        .padding([.horizontal, .bottom])
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
