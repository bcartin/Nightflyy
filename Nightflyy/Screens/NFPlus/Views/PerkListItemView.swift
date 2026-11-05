//
//  PerkListItemView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/5/26.
//

import SwiftUI

/// Row showing a Nightflyy+ venue or event perk. When selected it expands in place to show
/// the redemption instructions; it stays the same view so SwiftUI animates the size change
/// instead of swapping views.
struct PerkListItemView: View {

    let perk: NFPPerk
    let isSelected: Bool
    let selectAction: ButtonAction
    let useAction: ButtonAction

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: selectAction) {
                HStack(spacing: 0) {
                    // A 70pt square with a 35pt radius is a circle, so the image morphs smoothly.
                    PerkImage(imageUrl: perk.imageUrl)
                        .clipShape(.rect(cornerRadius: isSelected ? 35 : 0))
                        .padding(isSelected ? 12 : 0)

                    VStack(alignment: .leading, spacing: 4) {
                        PerkTitleView(perk: perk)

                        if let perkDetails = perk.perkDetails, !perkDetails.isEmpty {
                            Text(perkDetails)
                                .font(.caption2)
                                .foregroundStyle(.gray)
                                .lineLimit(1)
                        }
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .contentShape(.rect)
            }
            .buttonStyle(.plain)

            // Always in the hierarchy; its height animates between 0 and its natural size.
            PerkRedemptionDetailsView(perk: perk, useAction: useAction)
                .frame(height: isSelected ? nil : 0, alignment: .top)
                .clipped()
                .opacity(isSelected ? 1 : 0)
                .allowsHitTesting(isSelected)
                .accessibilityHidden(!isSelected)
        }
        .frame(maxWidth: .infinity)
        .background(.white.opacity(0.05))
        .clipShape(.rect(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? .mainPurple : .gray.opacity(0.3), lineWidth: 1)
        }
    }
}
