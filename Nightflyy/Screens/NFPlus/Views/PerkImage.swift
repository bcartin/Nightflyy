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
    var size: CGFloat = 70

    var body: some View {
        if let imageUrl, !imageUrl.isEmpty {
            CachedAsyncImage(url: URL(string: imageUrl), size: .init(width: size, height: size), shape: .rect)
        } else {
            Image("venue_default")
                .resizable()
                .frame(width: size, height: size)
                .background(.white)
        }
    }
}
