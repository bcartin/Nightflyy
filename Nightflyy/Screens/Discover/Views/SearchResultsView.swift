//
//  TestResultsView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 7/14/25.
//

import SwiftUI

struct SearchResultsView: View {
    
    @Bindable var viewModel: SearchResultsListViewModel
    @FocusState var isSearchFieldFocused: Bool
    
    var body: some View {
            
            VStack(alignment: .leading) {
                
                TextField("", text: $viewModel.searchText, prompt: Text("Search").foregroundStyle(.white.opacity(0.5)))
                    .foregroundStyle(.white)
                    .padding(8)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .focused($isSearchFieldFocused)
                    .overlay {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.white.opacity(0.5))
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                            
                                Button(action: {
                                    viewModel.clearSearchResults()
                                }, label: {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundStyle(.gray)
                                        .padding(.trailing, 12)
                                })
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                
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
                        LazyVStack {
                            ForEach(viewModel.venueResultsViewModels, id: \.self) { vm in
                                VenueListItemView(viewModel: vm) {
                                    vm.navigateToProfile()
                                }
                            }
                        }
                    }
                    else if viewModel.selectedSegment == 3 {
                        LazyVStack {
                            ForEach(viewModel.personResultsViewModels, id: \.self) { vm in
                                PersonListItemView(viewModel: vm) {
                                    vm.navigateToProfile()
                                }
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
        .onAppear {
            isSearchFieldFocused = true
        }
    }
}
