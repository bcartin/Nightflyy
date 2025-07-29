//
//  UserImageRound.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/7/24.
//

import SwiftUI

struct UserImageRound: View {
    
    var imageUrl: String?
    var size: CGFloat
    
    var body: some View {
        
        
        if let url = imageUrl, !url.isEmpty {
            CachedAsyncImage(url: URL(string: url), size: .init(width: size, height: size), shape: .circle, contentMode: .fill)
        }
        else {
            Image(systemName: "person.crop.circle")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(Circle())
                .foregroundStyle(.white)
        }
    }
}
