//
//  PerkTitleView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/5/26.
//

import SwiftUI

/// Perk title with the Nightflyy+ badge, and the perk name underneath.
struct PerkTitleView: View {

    let perk: NFPPerk

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(perk.title)
                    .font(.footnote)
                    .bold()
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Image("plus_badge")
                    .resizable()
                    .frame(width: 16, height: 16)
            }

            Text(perk.perkName)
                .font(.footnote)
                .bold()
                .foregroundStyle(.onlineBlue)
                .lineLimit(1)
        }
    }
}
