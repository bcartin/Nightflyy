//
//  ReviewsDetailView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 7/14/25.
//

import SwiftUI

struct ReviewsDetailView: View {
    
    var viewModel: ReviewsDetailViewModel
    @State private var progress: CGFloat = 0.0
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 12) {
            
            RoundedRectangle(cornerRadius: 3)
                .fill(.gray.opacity(0.9))
                .frame(width: 86, height: 6)
                .safeAreaPadding(.top, 12)
                .padding(.bottom, 32)
            
            Text(viewModel.venueName)
                .font(.system(size: 18))
                .padding(.bottom, 24)
            
            Text(viewModel.formatedRating)
                .font(.system(size: 48))
            
            RatingStarsView(rating: viewModel.account.rating ?? 0)
            
            Text("Based on \(viewModel.numberOfReviews) reviews")
                .foregroundStyle(.gray)
                .font(.system(size: 13, weight: .bold))
            
            ratingLineView(maxRatring: "5", maxValue: viewModel.fiveStarMax, numberOfReviews: viewModel.fiveStarReviews)
            
            ratingLineView(maxRatring: "4", maxValue: viewModel.fourStarMax, numberOfReviews: viewModel.fourStarReviews)
            
            ratingLineView(maxRatring: "3", maxValue: viewModel.thressStarMax, numberOfReviews: viewModel.threeStarReviews)
            
            ratingLineView(maxRatring: "2", maxValue: viewModel.twoStarMax, numberOfReviews: viewModel.twoStarReviews)
            
            ratingLineView(maxRatring: "1", maxValue: viewModel.oneStarMax, numberOfReviews: viewModel.oneStarReviews)

            Text(viewModel.subTitleText)
                .font(.system(size: 13, weight: .bold))
                .padding(.vertical, 16)
            
            ForEach(viewModel.topLikesDislikes) { item in
                HStack {
                    Text(item.name)
                        .font(.system(size: 17))
                    
                    Spacer()
                    
                    Text("(\(item.count))")
                        .font(.system(size: 17))
                }
                .foregroundStyle(.gray)
                .padding(.horizontal, 24)
            }
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity)
        .foregroundStyle(.white)
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
    }
    
    @ViewBuilder
    func ratingLineView(maxRatring: String, maxValue: Double, numberOfReviews: Int) -> some View {
        HStack(alignment: .center, spacing: 0) {
            Text(maxRatring)
                .font(.system(size: 18))
            
            Text("⭐️")
                .font(.system(size: 14))
                .padding(.trailing)
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6)
                    .frame(width: viewModel.fullWidth, height: 12)
                    .foregroundStyle(.gray.opacity(0.3))
                
                RoundedRectangle(cornerRadius: 6)
                    .frame(width: maxValue * progress, height: 12)
                    .foregroundStyle(.mainPurple.gradient)
                    .animation(.easeInOut, value: progress)
            }
            
            Text("\(numberOfReviews)")
                .font(.system(size: 18))
                .padding(.leading)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 6)
        .onReceive(timer) { _ in
            if progress < 1.0 {
                progress += 0.025
            }
        }
    }
}

//#Preview {
//    ReviewsDetailView(viewModel: .init(account: .init(name: "Venue Name & Lounge")))
//}
