//
//  EventGuestListView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/21/25.
//

import SwiftUI

struct EventGuestListView: View {
    
    @Environment(Router.self) private var router
    @Bindable var viewModel: EventGuestListViewModel
    @State var searchText: String = ""
    
    var body: some View {
        VStack {
            
            SegmentedView(segments: viewModel.segments, selected: $viewModel.selectedSegment)
            
            ScrollView {
                if viewModel.selectedSegment == 1 {
                    ForEach(viewModel.event.attending ?? [], id: \.self) { uid in
                        LazyVStack(spacing: 0) {
                            let viewModel = NetworkUserViewModel(selectedSegment: viewModel.selectedSegment)
                            NetworkUserView(viewModel: viewModel)
                                .task {
                                    await viewModel.fetchAccount(uid: uid)
                                }
                                .onTapGesture {
                                    viewModel.goToProfile()
                                }
                            
                        }
                    }
                }
                else if viewModel.selectedSegment == 2 {
                    ForEach(viewModel.event.interested ?? [], id: \.self) { uid in
                        LazyVStack(spacing: 0) {
                            let viewModel = NetworkUserViewModel(selectedSegment: viewModel.selectedSegment)
                            NetworkUserView(viewModel: viewModel)
                                .task {
                                    await viewModel.fetchAccount(uid: uid)
                                }
                                .onTapGesture {
                                    viewModel.goToProfile()
                                }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
//        .searchable(text: $searchText)
    }
}

#Preview {
    EventGuestListView(viewModel: EventGuestListViewModel(event: Event(), selectedSegment: 1))
}
