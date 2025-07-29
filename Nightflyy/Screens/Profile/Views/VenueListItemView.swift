//
//  VenueListItemView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/28/25.
//

import SwiftUI

struct VenueListItemView: View {
    
    var viewModel: VenueListItemViewModel
    var tapAction: ButtonAction? = nil
    
    var body: some View {
        HStack(spacing: 0) {
            
            if let profileImageUrl = viewModel.venue.profileImageUrl {
                CachedAsyncImage(url: URL(string: profileImageUrl), size: .init(width: 70, height: 70), shape: .rect)
                .cornerRadius(12, corners: [.bottomLeft, .topLeft])
            }
            else {
                Image("venue_default", bundle: .main)
                    .resizable()
                    .frame(width: 70, height: 70)
                    .background(.white)
                    .cornerRadius(12, corners: [.bottomLeft, .topLeft])
                    
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Group {
                    HStack(alignment: .center) {
                        Text(viewModel.venue.name ?? "")
                            .foregroundStyle(Color.white)
                            .fontWeight(.medium)
                            .font(.footnote)
                        if viewModel.isPlusVenue {
                            Image("plus_badge")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        
                        Spacer()
                    }
                    
                    Text(viewModel.venue.venueType ?? "")
                        .foregroundStyle(Color.mainPurple)
                        .font(.system(size: 12))
                    
                    HStack {
                        Text((viewModel.venue.city ?? "") + ", " + (viewModel.venue.state ?? ""))
                            .foregroundStyle(Color.gray)
                            .font(.system(size: 12))
                    }
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.opacity(0.05))
            .shadow(color: .gray.opacity(0.3), radius: 10.0)
            .cornerRadius(12, corners: [.topRight, .bottomRight])
        }
        .onTapGesture {
            tapAction?()
        }
    }
}
