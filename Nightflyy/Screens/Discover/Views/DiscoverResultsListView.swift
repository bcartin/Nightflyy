//
//  SearchResultsListView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/7/25.
//

import SwiftUI

struct DiscoverResultsListView: View {
    
    @Bindable var viewModel: SearchResultsListViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            
            SegmentedView(segments: viewModel.segments, selected: $viewModel.selectedSegment)
            
            ScrollView {
                if viewModel.selectedSegment == 0 {
                    LazyVStack {
                        ForEach(viewModel.searchResults) { searchResult in
                            switch searchResult.type {
                            case .event:
                                if let event = searchResult.event {
                                    let vm = EventListItemViewModel(event: event)
                                    EventListItemView(viewModel: vm) {
                                        vm.navigateToEvent()
                                    }
                                    .task {
                                        await vm.fetchOwner()
                                    }
                                }
                            case .person:
                                if let person = searchResult.account {
                                    let vm = PersonListItemViewModel(account: person)
                                    PersonListItemView(viewModel: vm) {
                                        vm.navigateToProfile()
                                    }
                                }
                            case .venue:
                                if let venue = searchResult.account {
                                    let vm = VenueListItemViewModel(venue: venue)
                                    VenueListItemView(viewModel: vm) {
                                        vm.navigateToProfile()
                                    }
                                }
                            }
                        }
                    }
                }
                else if viewModel.selectedSegment == 1 {
                    LazyVStack {
                        ForEach(viewModel.eventResultsViewModels, id: \.self) { vm in
                            EventListItemView(viewModel: vm) {
                                vm.navigateToEvent()
                            }
                            .task {
                                await vm.fetchOwner()
                            }
                        }
                    }
                }
                else if viewModel.selectedSegment == 2 {
                    ForEach(viewModel.venueResultsViewModels, id: \.self) { vm in
                        VenueListItemView(viewModel: vm) {
                            vm.navigateToProfile()
                        }
                    }
                }
                else if viewModel.selectedSegment == 3 {
                    ForEach(viewModel.personResultsViewModels, id: \.self) { vm in
                        PersonListItemView(viewModel: vm) {
                            vm.navigateToProfile()
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
        .foregroundStyle(.white)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Results")
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .medium))
            }
        }
    }
}

