//
//  CustomImage.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 1/31/25.
//

import SwiftUI

struct CustomImage: View {
    
    var imageUrl: String?
    var size: CGSize
    var placeholder: String
    var isSystemImage: Bool = true
    
    var body: some View {
        if let url = imageUrl {
            CachedAsyncImage(url: URL(string: url), size: .init(width: size.width, height: size.height), shape: .rect, contentMode: .fill)
        }
        else {
            PlaceholderImage()
        }
    }
    
    @ViewBuilder
    func PlaceholderImage() -> some View {
        if isSystemImage {
            Image(systemName: placeholder)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipped()
        }
        else {
            Image(placeholder)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipped()
        }
    }
    
}
