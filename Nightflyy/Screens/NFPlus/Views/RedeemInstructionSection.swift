//
//  RedeemInstructionSection.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/5/26.
//

import SwiftUI

/// Numbered step on the staff redemption screen, such as "2. How to Redeem".
struct RedeemInstructionSection<Content: View>: View {

    let number: Int
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(number). \(title)")
                .font(.headline)

            content
                .font(.footnote)
                .padding(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
