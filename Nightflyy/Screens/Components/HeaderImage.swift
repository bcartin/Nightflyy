//
//  HeaderImage.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/15/24.
//

import SwiftUI

struct HeaderImage<FooterView: View>: View {
    
    var size: CGSize
    var safeArea: EdgeInsets
    var imageUrl: String?
    var isShowingFullSizeImage: Bool = false
    var hideImage: Bool = false
    @ViewBuilder var footerView: () -> FooterView
    
    var body: some View {
            let height = size.height * 0.45
            GeometryReader{ proxy in
                let size = proxy.size
                let minY = proxy.frame(in: .named("SCROLL")).minY
                let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
                
                imageView()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height + (minY > 0 ? minY : 0))
                .clipped()
                .overlay(content: {
                    ZStack(alignment: .bottom) {
                        Rectangle()
                            .fill(
                                .linearGradient(colors: [
                                    .backgroundBlack.opacity(0 - progress),
                                    .backgroundBlack.opacity(0.1 - progress),
                                    .backgroundBlack.opacity(0.2 - progress),
                                    .backgroundBlack.opacity(0.3 - progress),
                                    .backgroundBlack.opacity(0.4 - progress),
                                    .backgroundBlack.opacity(0.6 - progress),
                                    .backgroundBlack.opacity(0.8 - progress),
                                    .backgroundBlack.opacity(1)
                                ], startPoint: .top, endPoint: .bottom)
                            )
                        
                        footerView()
                            .opacity(1 + (progress > 0 ? -progress : progress))
                            .padding(.horizontal, 12)
                            .offset(y: minY < 0 ? minY : 0)
                    }
                })
                .offset(y: -minY)
            }
            .frame(height: height + safeArea.top)
    }
    
    @ViewBuilder
    func imageView() -> some View {
        if hideImage {
            Image(systemName: "eye.slash")
                .font(.largeTitle)
        }
        else {
            if let imageUrl {
                BasicCachedAsyncImage(url: URL(string: imageUrl))
            }
            else {
                Image("ic_noImage")
                    .foregroundStyle(.mainPurple)
            }
        }
    }
}

