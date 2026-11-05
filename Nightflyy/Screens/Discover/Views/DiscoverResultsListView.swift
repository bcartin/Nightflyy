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
                                    let itemViewModel = EventListItemViewModel(event: event)
                                    EventListItemView(viewModel: itemViewModel) {
                                        itemViewModel.navigateToEvent()
                                    }
                                    .task {
                                        await itemViewModel.fetchOwner()
                                    }
                                }
                            case .person:
                                if let person = searchResult.account {
                                    let itemViewModel = PersonListItemViewModel(account: person)
                                    PersonListItemView(viewModel: itemViewModel) {
                                        itemViewModel.navigateToProfile()
                                    }
                                }
                            case .venue:
                                if let venue = searchResult.account {
                                    let itemViewModel = VenueListItemViewModel(venue: venue)
                                    VenueListItemView(viewModel: itemViewModel) {
                                        itemViewModel.navigateToProfile()
                                    }
                                }
                            }
                        }
                    }
                } else if viewModel.selectedSegment == 1 {
                    LazyVStack {
                        ForEach(viewModel.eventResultsViewModels, id: \.self) { itemViewModel in
                            EventListItemView(viewModel: itemViewModel) {
                                itemViewModel.navigateToEvent()
                            }
                            .task {
                                await itemViewModel.fetchOwner()
                            }
                        }
                    }
                } else if viewModel.selectedSegment == 2 {
                    ForEach(viewModel.venueResultsViewModels, id: \.self) { itemViewModel in
                        VenueListItemView(viewModel: itemViewModel) {
                            itemViewModel.navigateToProfile()
                        }
                    }
                } else if viewModel.selectedSegment == 3 {
                    ForEach(viewModel.personResultsViewModels, id: \.self) { itemViewModel in
                        PersonListItemView(viewModel: itemViewModel) {
                            itemViewModel.navigateToProfile()
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
