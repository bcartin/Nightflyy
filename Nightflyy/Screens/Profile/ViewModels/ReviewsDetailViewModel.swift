//
//  ReviewsDetailViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 7/14/25.
//

import Foundation

@Observable @MainActor
class ReviewsDetailViewModel {
    
    var account: Account
    var fives: [Review] = .init()
    var fours: [Review] = .init()
    var threes: [Review] = .init()
    var twos: [Review] = .init()
    var ones: [Review] = .init()
    var groupedReviews: Dictionary<Int, [Review]>
    var topLikesDislikes: [ReviewItem] = .init()

    var fullWidth: Double = 250.0
    
    init(account: Account) {
        self.account = account
        groupedReviews = Dictionary(grouping: account.reviews ?? .init(), by: {$0.rating})
        fives = groupedReviews[5] ?? []
        fours = groupedReviews[4] ?? []
        threes = groupedReviews[3] ?? []
        twos = groupedReviews[2] ?? []
        ones = groupedReviews[1] ?? []
        setupLikesDislikes()
    }
    
    var venueName: String {
        return account.name ?? ""
    }
    
    var formatedRating: String {
        guard let rating = account.rating else { return "0.0" }
        return String(format:"%.1f", rating)
    }
    
    var numberOfReviews: Int {
        guard let reviewsCount = account.reviews?.count else { return 0 }
        return reviewsCount
    }
    
    var fiveStarReviews: Int {
        fives.count
    }
    
    var fiveStarMax: CGFloat {
        return numberOfReviews > 0 ? (Double(fiveStarReviews / numberOfReviews)) * fullWidth : 0
    }
    
    var fourStarReviews: Int {
        fours.count
    }
    
    var fourStarMax: CGFloat {
        return numberOfReviews > 0 ? (Double(fourStarReviews / numberOfReviews)) * fullWidth : 0
    }
    
    var threeStarReviews: Int {
        threes.count
    }
    
    var thressStarMax: CGFloat {
        return numberOfReviews > 0 ? (Double(threeStarReviews / numberOfReviews)) * fullWidth : 0
    }
    
    var twoStarReviews: Int {
        twos.count
    }
    
    var twoStarMax: CGFloat {
        return numberOfReviews > 0 ? (Double(twoStarReviews / numberOfReviews)) * fullWidth : 0
    }
    
    var oneStarReviews: Int {
        ones.count
    }
    
    var oneStarMax: CGFloat {
        return numberOfReviews > 0 ? (Double(oneStarReviews / numberOfReviews)) * fullWidth : 0
    }
    
    var subTitleText: String {
        let likeDislike = account.rating ?? 0 > 3.0 ? "Like" : "Dislike"
        return "People \(likeDislike)"
    }
    
    func setupLikesDislikes() {
        var likes: [String] = .init()
        var dislikes: [String] = .init()
        
        var dislikesArray = ones.compactMap{$0.dislikes}.reduce([], +)
        dislikes.append(contentsOf: dislikesArray)
        dislikesArray = twos.compactMap{$0.dislikes}.reduce([], +)
        dislikes.append(contentsOf: dislikesArray)
        dislikesArray = threes.compactMap{$0.dislikes}.reduce([], +)
        dislikes.append(contentsOf: dislikesArray)
        var likesArray = fours.compactMap{$0.likes}.reduce([], +)
        likes.append(contentsOf: likesArray)
        likesArray = fives.compactMap{$0.likes}.reduce([], +)
        likes.append(contentsOf: likesArray)
        
        let groupedLikes = Dictionary(grouping: likes, by: {$0})
        let groupedDislikes = Dictionary(grouping: dislikes, by: {$0})
        
        if account.rating ?? 0 > 3.0 {
            groupedLikes.forEach { (key, value) in
                topLikesDislikes.append(ReviewItem(name: key, count: value.count))
            }
        }
        else {
            groupedDislikes.forEach { (key, value) in
                topLikesDislikes.append(ReviewItem(name: key, count: value.count))
            }
        }
        
        topLikesDislikes.sort{$0.count > $1.count}
        let topItems = min(3, topLikesDislikes.count - 1)
        topLikesDislikes = Array(topLikesDislikes.prefix(through: topItems))
    }
   
}

struct ReviewItem: Identifiable {
    
    let id = UUID().uuidString
    let name: String
    let count: Int
}
