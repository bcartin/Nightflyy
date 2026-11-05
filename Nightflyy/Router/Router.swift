//
//  Router.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/29/24.
//

import Foundation
import SwiftUI

@Observable @MainActor
class Router {

    static var shared = Router()

    private init() {}

    enum Route: Hashable {
        case profile(ProfileViewModel)
        case event(EventViewModel)
        case network(NetworkViewModel)
        case inviteToEvent(InviteToEventViewModel)
        case eventGuestList(EventGuestListViewModel)
        case createEvent(CreateEventViewModel)
        case searchResultsListView(SearchResultsListViewModel)
        case chatView(InboxRowViewModel)
        case reviewVenueView(ReviewVenueViewModel)
        case sendObjectAsMessage(SendObjectAsMessageViewModel)
        case notFound(NotFoundView.ContentType)
    }

    var path: NavigationPath = NavigationPath()

    @ViewBuilder
    func view(for route: Route) -> some View {
        switch route {
        case .profile(let viewModel):
            GeometryReader {
                let safeArea = $0.safeAreaInsets
                let size = $0.size

                if viewModel.isPersonalAccount {
                    ProfileView(viewModel: viewModel, safeArea: safeArea, size: size)
                        .ignoresSafeArea(.container, edges: .top)
                } else {
                    VenueProfileView(viewModel: viewModel, safeArea: safeArea, size: size)
                        .ignoresSafeArea(.container, edges: .top)
                }
            }
        case .event(let viewModel):
            GeometryReader {
                let safeArea = $0.safeAreaInsets
                let size = $0.size

                EventView(viewModel: viewModel, safeArea: safeArea, size: size)
                    .ignoresSafeArea(.container, edges: .top)
            }
        case .network(let viewModel):
            NetworkView(viewModel: viewModel)
        case .inviteToEvent(let viewModel):
            InviteToEventView(viewModel: viewModel)
        case .eventGuestList(let viewModel):
            EventGuestListView(viewModel: viewModel)
        case .createEvent(let viewModel):
            CreateEventView(viewModel: viewModel)
        case .searchResultsListView(let viewModel):
            DiscoverResultsListView(viewModel: viewModel)
        case .chatView(let viewModel):
            ChatView(viewModel: viewModel)
        case .reviewVenueView(let viewModel):
            ReviewVenueView(viewModel: viewModel)
        case .sendObjectAsMessage(let viewModel):
            SendObjectAsMessageView(viewModel: viewModel)
        case .notFound(let type):
            NotFoundView(contentType: type)
        }

    }

    func navigateTo(_ appRoute: Route) {
        withAnimation {
            path.append(appRoute)
        }
    }

    func navigateBack() {
        if path.count == 0 { return }
        withAnimation {
            path.removeLast()
        }
    }

    func popToRoot() {
        withAnimation {
            path.removeLast(path.count)
        }
    }

    func popLast(numberOfViews: Int) {
        withAnimation {
            for _ in 1...numberOfViews {
                navigateBack()
            }
        }
    }

}

extension Router {

    func navigateToProfile(account: Account?) {
        guard let account else {
            self.navigateTo(.notFound(.profile))
            return
        }
        let viewModel = ProfileViewModel(account: account)
        self.navigateTo(.profile(viewModel))
    }

    func navigateToEvent(event: Event?, eventOwner: Account? = nil) {
        guard let event else {
            self.navigateTo(.notFound(.event))
            return
        }
        let viewModel = EventViewModel(event: event, eventOwner: eventOwner)
        self.navigateTo(.event(viewModel))
    }

}
