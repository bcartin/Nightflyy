//
//  PerkImage.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/5/26.
//

import SwiftUI

/// Square venue or event image for a perk, falling back to the default venue image.
struct PerkImage: View {

    let imageUrl: String?

    var body: some View {
        if let imageUrl, !imageUrl.isEmpty {
            CachedAsyncImage(url: URL(string: imageUrl), size: .init(width: 70, height: 70), shape: .rect)
        } else {
            Image("venue_default")
                .resizable()
                .frame(width: 70, height: 70)
                .background(.white)
        }
    }
}
