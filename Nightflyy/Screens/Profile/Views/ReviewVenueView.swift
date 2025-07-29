//
//  ReviewVenueView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/23/25.
//

import SwiftUI

struct ReviewVenueView: View {
    
    @Bindable var viewModel: ReviewVenueViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                CustomImage(imageUrl: viewModel.account.profileImageUrl, size: .init(width: 200, height: 200), placeholder: "ic_noImage", isSystemImage: false)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12).stroke(.mainPurple)
                    }
                    .padding(.vertical, 24)
                
                Text("How would you rate your recent experience at")
                    .font(.system(size: 17))
                
                Text(viewModel.account.name ?? "")
                    .font(.system(size: 24, weight: .medium))
                    .padding(.vertical)
                
                HStack {
                    ForEach(1..<6) { value in
                        StarButton(value: value)
                    }
                }
                
                Spacer()
                
                if viewModel.showPickers {
                    
                    Text(viewModel.pickersHeader)
                        .font(.system(size: 14))
                    
                    TagSelectView(tags: viewModel.pickersList, selectedTags:  viewModel.didLike ? $viewModel.likes : $viewModel.dislikes)
                }
                
                Button("Submit") {
                    viewModel.submitReview()
                }
                .mainButtonStyle()
                .padding(.top, viewModel.showPickers ? 0 : 36)
                .padding(.bottom, 24)
            }
            .errorAlert(error: $viewModel.error, buttonTitle: "OK")
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
    }
    
    @ViewBuilder
    func StarButton(value: Int) -> some View {
        Button {
            viewModel.setRating(value: value)
        } label: {
            Image(systemName: viewModel.getButtonImage(for: value))
                .font(.system(size: 36))
                .foregroundStyle(.yellow)
        }

        
    }
}

#Preview {
    ReviewVenueView(viewModel: ReviewVenueViewModel(account: Account(name: "The River Room", profileImageUrl: "https://images-platform.99static.com/jo3g1M44U4aPBIGR8OnW3kBGTdw=/193x2405:1005x3217/500x500/top/smart/99designs-contests-attachments/87/87553/attachment_87553535")))
}
