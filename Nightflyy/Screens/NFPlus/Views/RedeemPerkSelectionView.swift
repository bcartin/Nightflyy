//
//  RedeemPerkSelectionView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/5/26.
//

import SwiftUI

/// Lets a member pick which Nightflyy+ venue or event perk to redeem.
struct RedeemPerkSelectionView: View {

    @Binding var viewModel: NFPRedeemViewModel

    var body: some View {
        VStack(spacing: 8) {
            Text("What perk would you like\nto use today?")
                .font(.title3)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.top, 48)
                .padding()

            PerkSearchField(searchText: $viewModel.perkSearchText, prompt: viewModel.perkSearchPrompt)

            if viewModel.selectedPerkId == nil {
                SegmentedView(segments: viewModel.perkSegments, selected: $viewModel.selectedPerkSegment)
                    .padding(.horizontal)
            }

            ScrollView(.vertical) {
                // VStack rather than LazyVStack: the list is short, and lazy stacks animate height changes poorly.
                VStack {
                    ForEach(viewModel.displayedPerks) { perk in
                        PerkListItemView(perk: perk,
                                         isSelected: perk.id == viewModel.selectedPerkId,
                                         selectAction: { viewModel.perkTapped(perk) },
                                         useAction: viewModel.usePerk)
                    }
                }
                .padding()
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.immediately)
        }
    }
}

#Preview {
    RedeemPerkSelectionView(viewModel: .constant(NFPRedeemViewModel()))
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
        .foregroundStyle(.white)
}
