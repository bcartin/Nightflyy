//
//  Router.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/29/24.
//

import Foundation
import SwiftUI

@Observable
class Router {
    
    static var shared = Router()
    
    private init() {}
    
    enum Route: Hashable {
        case Profile(ProfileViewModel)
        case Event(EventViewModel)
        case Network(NetworkViewModel)
        case InviteToEvent(InviteToEventViewModel)
        case EventGuestList(EventGuestListViewModel)
        case CreateEvent(CreateEventViewModel)
        case SearchResultsListView(SearchResultsListViewModel)
        case ChatView(InboxRowViewModel)
        case ReviewVenueView(ReviewVenueViewModel)
    }
    
    var path: NavigationPath = NavigationPath()
    
    @ViewBuilder
    func view(for route: Route) -> some View {
        switch route {
        case .Profile(let viewModel):
            GeometryReader {
                let safeArea = $0.safeAreaInsets
                let size = $0.size
                
                if viewModel.isPersonalAccount {
                    ProfileView(viewModel: viewModel, safeArea: safeArea, size: size)
                        .ignoresSafeArea(.container, edges: .top)
                }
                else {
                    VenueProfileView(viewModel: viewModel, safeArea: safeArea, size: size)
                        .ignoresSafeArea(.container, edges: .top)
                }
            }
        case .Event(let viewModel):
            GeometryReader {
                let safeArea = $0.safeAreaInsets
                let size = $0.size
                
                EventView(viewModel: viewModel, safeArea: safeArea, size: size)
                    .ignoresSafeArea(.container, edges: .top)
            }
        case .Network(let viewModel):
            NetworkView(viewModel: viewModel)
        case .InviteToEvent(let viewModel):
            InviteToEventView(viewModel: viewModel)
        case .EventGuestList(let viewModel):
            EventGuestListView(viewModel: viewModel)
        case .CreateEvent(let viewModel):
            CreateEventView(viewModel: viewModel)
        case .SearchResultsListView(let viewModel):
            DiscoverResultsListView(viewModel: viewModel)
        case .ChatView(let viewModel):
            ChatView(viewModel: viewModel)
        case .ReviewVenueView(let viewModel):
            ReviewVenueView(viewModel: viewModel)
        }
    
    }
    
    func navigateTo(_ appRoute: Route) {
        withAnimation {
            path.append(appRoute)
        }
    }
    
    func navigateBack() {
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
            for _ in 0...numberOfViews {
                navigateBack()
            }
        }
    }
    
}
