//
//  EventImage.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/11/24.
//

import SwiftUI

struct EventImage: View {
    
    var imageUrl: String?
    var size: CGSize
    var contentMode: ContentMode = .fill
    
    var body: some View {
        if let url = imageUrl, !url.isEmpty {
            CachedAsyncImage(url: URL(string: url),
                             size: .init(width: size.width, height: size.height),
                             shape: .rect)
        }
        else {
            Image(systemName: "questionmark.square.dashed")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .foregroundStyle(.mainPurple)
                .background(.white.opacity(0.1))
        }
    }
}
