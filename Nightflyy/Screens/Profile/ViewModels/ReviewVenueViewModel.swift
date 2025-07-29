//
//  ReviewVenueViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/23/25.
//

import Foundation

@Observable
class ReviewVenueViewModel: NSObject {
    
    var rating: Int = 0
    var likes: [String] = []
    var dislikes: [String] = []
    var account: Account
    var error: Error?
    
    init(account: Account) {
        self.account = account
    }
    
    var showPickers: Bool {
        return rating > 0
    }
    
    var didLike: Bool {
        return rating > 3
    }
    
    var pickersHeader: String {
        return didLike ? "What did you like?" : "What didn't you like?"
    }
    
    var pickersList: [String] {
        return didLike ? listOfLikes : listOfDislikes
    }
    
    var listOfLikes = ["Speedy Entry Line",
                       "Location",
                       "Atmosphere",
                       "Nice Crowd",
                       "Unique Vibe",
                       "Good Music",
                       "Drink Quality",
                       "VIP Experience",
                       "Good Food",
                       "Great Events",
                       "Good Bartending/Service",
                       "Prices"]
    
    var listOfDislikes = ["Expensive Cover",
                          "Security",
                          "Long Line",
                          "Too Packed",
                          "Lack of People",
                          "Bad Music",
                          "Drink Quality",
                          "VIP Experience",
                          "Cleanliness",
                          "Bad Events",
                          "Poor Bartending/Service",
                          "Crowd"]
    
    func getButtonImage(for value: Int) -> String {
        return value <= rating ? "star.fill" : "star"
    }
    
    func setRating(value: Int) {
        rating = value
    }
    
    func submitReview() {
        do {
            guard let uid = AccountManager.shared.account?.uid else { return }
            let review = Review(reviewer: uid,
                                rating: rating,
                                likes: likes,
                                dislikes: dislikes,
                                date: Date())
            try AccountClient.submitReview(accountId: account.uid, review: review)
            try saveReviewNotification()
            General.showSuccessMessage(message: "Review Submitted")
            Router.shared.navigateBack()
        }
        catch {
            self.error = error
        }
    }
    
    func saveReviewNotification() throws {
        guard let myAccount = AccountManager.shared.account else { return }
        let notification = AppNotification(sender: myAccount.uid, date: Date(), type: .review_submitted, notificationData: NotificationData(profile_image_url: myAccount.profileImageUrl, username: myAccount.username))
        try AppNotificationClient.saveNotification(for: account.uid, notification: notification)
    }
}
