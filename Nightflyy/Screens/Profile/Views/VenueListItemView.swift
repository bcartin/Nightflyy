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
                AsyncImage(url: URL(string: profileImageUrl)) { image in
                    image.image?.resizable()
                }
                .frame(width: 70, height: 70)
                .cornerRadius(12, corners: [.bottomLeft, .topLeft])
            }
            else {
                Image("venue_default", bundle: .main)
                    .resizable()
                    .frame(width: 70, height: 70)
                    .background(.white)
                    .cornerRadius(12, corners: [.bottomLeft, .topLeft])
                    
            }
            
            VStack(alignment: .leading) {
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
                        .font(.footnote)
                    
                    HStack {
                        Text((viewModel.venue.city ?? "") + ", " + (viewModel.venue.state ?? ""))
                            .foregroundStyle(Color.gray)
                            .font(.footnote)
                    }
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.opacity(0.05))
            .cornerRadius(12, corners: [.topRight, .bottomRight])
        }
        .onTapGesture {
            tapAction?()
        }
    }
}
