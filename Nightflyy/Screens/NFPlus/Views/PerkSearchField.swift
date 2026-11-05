//
//  PerkSearchField.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/5/26.
//

import SwiftUI

/// Search field for filtering Nightflyy+ perks by name or city.
struct PerkSearchField: View {

    @Binding var searchText: String
    let prompt: String

    var body: some View {
        let field = HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.callout)
                .foregroundStyle(.white.opacity(0.5))

            TextField("", text: $searchText, prompt: Text(prompt).foregroundStyle(.white.opacity(0.5)))
                .font(.subheadline)
                .submitLabel(.search)
                .autocorrectionDisabled()

            if !searchText.isEmpty {
                Button("Clear search", systemImage: "xmark.circle.fill") {
                    searchText = ""
                }
                .labelStyle(.iconOnly)
                .font(.callout)
                .foregroundStyle(.white.opacity(0.5))
            }
        }
        .padding(.horizontal)

        if #available(iOS 26.0, *) { // TODO: Remove when min version is iOS 26
            field
                .frame(height: 44)
                .glassEffect(.regular, in: .capsule)
                .padding(.horizontal)
        } else {
            field
                .frame(height: 40)
                .background(Color(.systemGray6))
                .clipShape(.rect(cornerRadius: 8))
                .padding(.horizontal)
        }
    }
}
