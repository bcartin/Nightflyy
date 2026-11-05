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

                if #available(iOS 26.0, *) { // TODO: Remove when min version is iOS 26
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.callout)
                            .foregroundStyle(.white.opacity(0.5))

                        TextField("", text: $viewModel.searchText, prompt: Text("Search").foregroundStyle(.white.opacity(0.5)))
                            .submitLabel(.search)
                            .focused($isSearchFieldFocused)

                        if !viewModel.searchText.isEmpty {
                            Button {
                                viewModel.clearSearchResults()
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.callout)
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 44)
                    .glassEffect(.regular, in: .capsule)
                    .padding(.top, 8)
                    .padding(.horizontal, 16)
                } else {
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.callout)
                            .foregroundStyle(.white.opacity(0.5))

                        TextField("", text: $viewModel.searchText, prompt: Text("Search").foregroundStyle(.white.opacity(0.5)))
                            .submitLabel(.search)
                            .focused($isSearchFieldFocused)

                        if !viewModel.searchText.isEmpty {
                            Button {
                                viewModel.clearSearchResults()
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.callout)
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 40)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.top, 8)
                    .padding(.horizontal, 16)

                }

//                TextField("", text: $viewModel.searchText, prompt: Text("Search").foregroundStyle(.white.opacity(0.5)))
//                    .foregroundStyle(.white)
//                    .padding(8)
//                    .padding(.horizontal, 25)
//                    .background(Color(.systemGray6))
//                    .cornerRadius(8)
//                    .focused($isSearchFieldFocused)
//                    .overlay {
//                        HStack {
//                            Image(systemName: "magnifyingglass")
//                                .foregroundStyle(.white.opacity(0.5))
//                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
//                                .padding(.leading, 8)
//                            
//                                Button(action: {
//                                    viewModel.clearSearchResults()
//                                }, label: {
//                                    Image(systemName: "multiply.circle.fill")
//                                        .foregroundStyle(.gray)
//                                        .padding(.trailing, 12)
//                                })
//                        }
//                    }
//                    .padding(.horizontal)
//                    .padding(.top, 8)

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
                        LazyVStack {
                            ForEach(viewModel.venueResultsViewModels, id: \.self) { itemViewModel in
                                VenueListItemView(viewModel: itemViewModel) {
                                    itemViewModel.navigateToProfile()
                                }
                            }
                        }
                    } else if viewModel.selectedSegment == 3 {
                        LazyVStack {
                            ForEach(viewModel.personResultsViewModels, id: \.self) { itemViewModel in
                                PersonListItemView(viewModel: itemViewModel) {
                                    itemViewModel.navigateToProfile()
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
