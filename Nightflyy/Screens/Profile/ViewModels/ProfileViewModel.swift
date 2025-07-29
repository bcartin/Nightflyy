//
//  ProfileViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/13/24.
//

import Foundation
import SwiftUI

@Observable
class ProfileViewModel: NSObject {
    
    var account: Account
    
    var error: Error?
    var attendingEvents: [EventListItemViewModel] = .init()
    var pastHostingEvents: [EventListItemViewModel] = .init()
    var futureHostingEvents: [EventListItemViewModel] = .init()
    var followingStatus: FollowingStatus = .notFollowing
    
    var presentUnfollowAlert: Bool = false
    var presentBlockAlert: Bool = false
    var presentSheetScreen: Bool = false
    var presentOptionsDialog: Bool = false
    var presentContactDialog: Bool = false
    var selectedPresentView: PresentSheetView?
    
    init(account: Account) {
        self.account = account
        super.init()
        self.setFollowingStatus()
        print(account.uid)
    }
    
    var isSelf: Bool {
        return account.uid == AccountManager.shared.account?.uid
    }
    
    var hasBio: Bool {
        return account.bio != nil && account.bio != ""
    }
    
    var isPersonalAccount: Bool {
        return account.accountType == .personal
    }
    
    var isPlusProvider: Bool {
        account.plusProvider ?? false
    }
    
    var isPlusAccount: Bool {
        account.plusMember ?? false
    }
    
    var hasPhoneNumber: Bool {
        return account.phoneNumber != nil && account.phoneNumber != ""
    }
    
    var hasBusinessEmail: Bool {
        return account.businessEmail != nil && account.businessEmail != ""
    }
    
    var canContact: Bool {
        return hasPhoneNumber || hasBusinessEmail
    }
    
    var callUrl: URL? {
        let okayChars = Set("1234567890+")
        guard let strippedPhoneNumber = account.phoneNumber?.filter({okayChars.contains($0)}) else {
            return nil
        }
        return URL(string: "tel://\(strippedPhoneNumber)")
    }
    
    var prettyPhoneNumber: String {
        let number = account.phoneNumber
        let areaCode = number?.prefix(3)
        let last7 = number?.suffix(7)
        let prefix = last7?.prefix(3)
        let lineNumber = last7?.suffix(4)
        return "\(areaCode ?? "")-\(prefix ?? "")-\(lineNumber ?? "")"
    }
    
    var businessEmail: String? {
        return account.businessEmail
    }
    
    var followButtonProperties: (icon: String, title: String, color: Color) {
        let icon = followingStatus == .following ? "ic_following" : "ic_follow"
        let title = followingStatus == .following ? "Following" : followingStatus == .requested ? "Requested" : "Follow"
        let color = followingStatus == .notFollowing ? Color.white : Color.mainPurple
        
        return (icon, title, color)
    }
    
    var canInteract: Bool {
        if isSelf {
            return true
        }
        else {
            return account.accountIsPrivate ?? true && followingStatus != .following ? false : true
        }
    }
    
    var hasWebsite: Bool {
        guard var website = account.website else {
            return false
        }
        website = "https://" + website
        return UIApplication.shared.canOpenURL(URL(string: website)!)
        
    }
    
    func setFollowingStatus() {
        self.followingStatus = AccountManager.shared.account?.getFollowingStatus(uid: account.uid) ?? .notFollowing
    }
    
    func loadAccountEvents() async {
        if isSelf {
            await EventsManager.shared.fetchHostingEvents()
            await EventsManager.shared.fetchHubEvents()
            
            attendingEvents = EventsManager.shared.attendingEvents.map{EventListItemViewModel(event: $0)}.sortedByDate()
            pastHostingEvents = EventsManager.shared.hostingEvents.onlyPastEvents().map{EventListItemViewModel(event: $0)}.sortedByDate()
            futureHostingEvents = EventsManager.shared.hostingEvents.removingPastEvents().map{EventListItemViewModel(event: $0)}.sortedByDate()
        }
        else {
            if attendingEvents.isEmpty {
                attendingEvents = await EventClient.fetchEventsAttending(uid: account.uid).map{EventListItemViewModel(event: $0)}.sortedByDate()
            }
            if futureHostingEvents.isEmpty || pastHostingEvents.isEmpty {
                let hostingEvents = await EventClient.fetchEventsHostedBy(uid: account.uid)
                pastHostingEvents = hostingEvents.onlyPastEvents().map{EventListItemViewModel(event: $0)}.sortedByDate()
                futureHostingEvents = hostingEvents.removingPastEvents().map{EventListItemViewModel(event: $0)}.sortedByDate()
            }
        }
    }
    
    func followButtonAction() {
        do {
            switch followingStatus {
            case .notFollowing:
                if account.accountIsPrivate ?? true {
                    try AccountManager.shared.requestToFollowAccount(accountId: account.uid)
                }
                else {
                    try AccountManager.shared.followAccount(accountToFollow: &account)
                }
            case .following:
                self.presentUnfollowAlert = true
            case .requested:
                print("Already Requested")
            }
            setFollowingStatus()
        }
        catch {
            self.error = error
        }
    }
    
    func unfollowAccount() {
        do {
            try AccountManager.shared.unfollowAccount(accountToFollow: &account)
            setFollowingStatus()
            self.presentUnfollowAlert = false
        }
        catch {
            self.error = error
        }
    }
    
    func updateAccount() {
        if let account = AccountManager.shared.account, isSelf {
            self.account = account
        }
    }
    
    func messageButtonAction() {
        let chat =  ChatsManager.shared.getChat(with: account.uid)
        let viewModel = InboxRowViewModel(chat: chat)
        Router.shared.navigateTo(.ChatView(viewModel))
    }
    
    func handleOptionsTapped() {
        if isSelf {
            selectPresentView(for: .editScreen)
        }
        else {
            presentOptionsDialog = true
        }
    }
    
    func handleBlockTapped() {
        Task {
            do {
                try await ReportsClient.blockAccount(accountId: account.uid)
                presentBlockAlert = false
            }
            catch {
                self.error = error
            }
        }
    }
    
}

extension ProfileViewModel {
    
    enum PresentSheetView {
        case editScreen
        case sendAsMessage
        case report
        case paywall
        case review
    }
    
    func selectPresentView(for value: PresentSheetView) {
        selectedPresentView = value
        presentSheetScreen = true
        presentOptionsDialog = false
    }
}

extension ProfileViewModel { // VENUE SPECIFIC FIELDS & FUNCTIONS
    
    
    var formatedRating: String {
        guard let rating = account.rating else { return "0.0" }
        return String(format:"%.1f", rating)
    }
    
    var numberOfReviews: String {
        guard let reviewsCount = account.reviews?.count else { return "0" }
        return "\(reviewsCount)"
    }
    
//    func getNumberOfReviews() {
//        Task {
//            if !isPersonalAccount {
//                account.reviews = await AccountClient.fetchAccountReviews(for: account.uid)
//            }
//        }
//    }
    
    func openWebsite() {
        guard var urlString = account.website else { return }
        urlString = "https://" + urlString
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    func openMapsWithAddress() {
        Task { @MainActor in
            guard let address = account.address else { return }
            await MapsManager.openMapsWithAddress(address)
        }
    }
    
    func goToReviewScreen() {
        let viewModel = ReviewVenueViewModel(account: account)
        Router.shared.navigateTo(.ReviewVenueView(viewModel))
    }
}
