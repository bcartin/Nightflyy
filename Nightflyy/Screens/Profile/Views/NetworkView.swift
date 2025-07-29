//
//  NetworkView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/15/24.
//

import SwiftUI

struct NetworkView: View {
    
    @Environment(Router.self) private var router
    @Bindable var viewModel: NetworkViewModel
    
    var body: some View {
        VStack {
            
            SegmentedView(segments: viewModel.segments, selected: $viewModel.selectedSegment)
            
            ScrollView {
                if viewModel.selectedSegment == 1 {
                    ForEach(viewModel.filteredFollowers, id: \.self) { uid in
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
                else {
                    ForEach(viewModel.account.following ?? [], id: \.self) { uid in
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
//        .searchable(text: $viewModel.searchText)
    }
        
}

#Preview {
    NetworkView(viewModel: NetworkViewModel(account: TestData.account, selectedSegment: 1))
        .preferredColorScheme(.dark)
}
