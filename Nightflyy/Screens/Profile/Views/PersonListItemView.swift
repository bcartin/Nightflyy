//
//  PersonListItemView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/9/25.
//

import SwiftUI

struct PersonListItemView: View {
    var viewModel: PersonListItemViewModel
    var tapAction: ButtonAction? = nil
    
    var body: some View {
        HStack(spacing: 0) {
            
            CustomImage(imageUrl: viewModel.account.profileImageUrl, size: .init(width: 70, height: 70), placeholder: "person.crop.circle")
                .cornerRadius(12, corners: [.bottomLeft, .topLeft])
            
            VStack(alignment: .leading, spacing: 4) {
                Group {
                    HStack(alignment: .center) {
                        Text(viewModel.account.username ?? "")
                            .foregroundStyle(Color.white)
                            .fontWeight(.medium)
                            .font(.footnote)
                        if viewModel.isPlusProvider {
                            Image("plus_badge")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        else if viewModel.isPlusMember {
                            Image("plus_badge_user")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        
                        Spacer()
                    }
                    
                    Text(viewModel.account.name ?? "")
                        .foregroundStyle(Color.mainPurple)
                        .font(.system(size: 12))
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

