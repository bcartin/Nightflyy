//
//  SearchView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/5/24.
//

import SwiftUI

struct DiscoverView: View {
    
    @Binding var showMenu: Bool
    @State var viewModel: DiscoverViewModel
    @State var isFilterViewShowing: Bool = false
    @State var isSearhing: Bool = false
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        RouterView {
            ScrollView {
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    TextField("", text: $viewModel.searchText, prompt: Text("Search").foregroundStyle(.white.opacity(0.5)))
                        .foregroundStyle(.white)
                        .padding(8)
                        .padding(.horizontal, 25)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .disabled(true)
                        .onTapGesture {
                            withAnimation {
                                self.isSearhing = true
                            }
                        }
                        .overlay {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(.white.opacity(0.5))
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 8)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    VStack(alignment: .leading) {
                        
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: 16) {
                                ForEach(viewModel.filteredDisplayEvents) { event in
                                    EventCardSmallView(viewModel: EventCardSmallViewModel(event: event))
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .scrollIndicators(.hidden)
                        .safeAreaPadding(12)
                        .scrollTargetBehavior(.viewAligned)
                        
                        HStack {
                            Button {
                                isFilterViewShowing.toggle()
                            } label: {
                                Text(viewModel.locationFilterButtonText)
                                    .foregroundStyle(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12).fill(.mainPurple)
                                    )
                            }
                            .fullScreenCover(isPresented: $isFilterViewShowing) {
                                EventsFilterView(viewModel: $viewModel.filterViewModel)
                            }
                            
                            Button {
                                viewModel.selectFilterView(.date)
                            } label: {
                                Text(viewModel.dateFilterButtonText)
                                    .foregroundStyle(.white)
                                    .padding()
                                    .frame(minWidth: 100)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12).fill(viewModel.hasDateFilter ? .mainPurple : .clear)
                                    )
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(viewModel.hasDateFilter ? .mainPurple : .white))
                            }
                            
                            Button {
                                viewModel.selectFilterView(.cover)
                            } label: {
                                Text(viewModel.coverFilterButtonText)
                                    .foregroundStyle(.white)
                                    .padding()
                                    .frame(minWidth: 80)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12).fill(viewModel.hasCoverFilter ? .mainPurple : .clear)
                                    )
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(viewModel.hasCoverFilter ? .mainPurple : .white, lineWidth: 1))
                            }
                            
                        }
                        .padding(.horizontal, 12)
                        
                        Text("Venue")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.horizontal)
                            .padding(.top)
                        
                        TagSelectView(tags: VenuesType.allValues, selectedTags: $viewModel.selectedVenues)
                        
                        Text("Music")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.horizontal)
                            .padding(.top)
                        
                        TagSelectView(tags: MusicGenre.allValues, selectedTags: $viewModel.selectedMusic)
                        
                        Text("Crowds")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.horizontal)
                            .padding(.top)
                        
                        TagSelectView(tags: ClienteleType.allValues, selectedTags: $viewModel.selectedCrowds)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .backgroundImage("slyde_background")
            .background(.backgroundBlack)
            .safeAreaPadding(.bottom, 44)
            .foregroundStyle(.white)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Discover")
                        .foregroundStyle(.white)
                        .font(.system(size: 18, weight: .medium))
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        showMenu.toggle()
                    }, label: {
                        Image(systemName: showMenu ? "xmark" : "line.3.horizontal")
                            .foregroundStyle(.white)
                            .contentTransition(.symbolEffect)
                    })
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        if isSearhing {
                            self.isSearhing = false
                        }
                        else {
                            viewModel.clearFilters()
                        }
                    }, label: {
                        Text(isSearhing ? "Cancel" : "Clear")
                            .foregroundStyle(.white)
                            .contentTransition(.symbolEffect)
                    })
                }
            }
            .overlay(alignment: .bottom) {
                if viewModel.hasResults && !isSearhing {
                    Button {
                        viewModel.navigateToResultsView()
                    } label: {
                        Text("Browse (\(viewModel.resultsCount) Results)")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(.mainPurple)
                    }
                }
            }
            .overlay(alignment: .bottom, content: {
                if isSearhing {
                    SearchResultsView(viewModel: viewModel.searchResultsViewModel)
                       
                }
            })
            .sheet(isPresented: $viewModel.presentFilterView) {
                switch viewModel.selectedFilterView {
                case .date:
                    DateFilterView(selectedDate: $viewModel.selectedDate)
                case .cover:
                    CoverFilterView(selectedMaxCover: $viewModel.selectedMaxCover)
                case .rating:
                    RatingFilterView(selectedRating: $viewModel.selectedRating)
                case .none:
                    EmptyView()
                }
                
            }
        }
        .scrollIndicators(.hidden)
    }
}
