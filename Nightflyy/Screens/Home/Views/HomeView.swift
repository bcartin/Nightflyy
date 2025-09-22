//
//  HomeView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 10/10/24.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(LocationManager.self) private var locationManager
    @Environment(ToastsManager.self) private var toastsManager
    @Binding var showMenu: Bool
    @State var isFilterViewShowing: Bool = false
    @State var viewModel: HomeViewModel
    
    var body: some View {
        @Bindable var toastsManager = toastsManager
        
        RouterView {
            VStack {
                Spacer()
                    .frame(height: 64)
                
                if !locationManager.permissionGranted && viewModel.selectedFiler == .nearby {
                    NoPermissionsView()
                }
                else if viewModel.displayEvents.isEmpty {
                    NoResultsView()
                }
                else {
                    
                    GeometryReader {
                        let size = $0.size
                        let cardWidth = size.width - 86
                        
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 0) {
                                ForEach(viewModel.displayEvents) { event in
                                    EventCardView(viewModel: EventCardViewModel(event: event), size: size)
                                        .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                                            content
                                                .scaleEffect(phase == .identity ? 1 : 0.9, anchor: .center)
                                        }
                                }
                                
                            }
                            .scrollTargetLayout()
                        }
                        .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
                        .safeAreaPadding(.horizontal, (size.width - cardWidth) / 2)
                        .scrollIndicators(.hidden)
                        .scrollPosition(id: $viewModel.scrollPosition)
                    }
                    .padding(.bottom, 112)
                }
                
                Spacer()
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.backgroundBlack)
            .foregroundStyle(.white)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button(action: {
                        
                    }, label: {
                        HStack {
                            Text(viewModel.headerText)
                                .font(.system(size: 18, weight: .medium))
                                .padding(.leading, 24)
                            Image(systemName: "chevron.down")
                        }
                        .foregroundStyle(.white)
                        .onTapGesture {
                            isFilterViewShowing.toggle()
                        }
                        .fullScreenCover(isPresented: $isFilterViewShowing) {
                            EventsFilterView(viewModel: $viewModel.filterViewModel)
                        }
                    })
                    
                    
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
                        viewModel.navigateToCreateNewEvent()
                    }, label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.white)
                            .contentTransition(.symbolEffect)
                    })
                }
            }
            .overlay(alignment: .bottom) {
                BottomSheetView()
                    .onTapGesture {
                        viewModel.showNFPView()
                    }
                    .fullScreenCover(isPresented: $viewModel.isShowingNFPView) {
                        NFPContainerView()
                    }
            }
            .interactiveToast($toastsManager.toasts)
        }
    }
    
    @ViewBuilder
    func NoPermissionsView() -> some View {
        VStack(alignment: .center, spacing: 24) {
            Image(systemName: "mappin.slash.circle.fill")
                .resizable()
                .frame(width: 44, height: 44)
                .foregroundColor(.mainPurple)
            
            Text("You did not grant location permissions. Allow Nightflyy to access your location to see nearby events.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Button {
                viewModel.openSettings()
            } label: {
                Text("Open Settings")
                    .foregroundStyle(.mainPurple)
                    .font(.subheadline)
            }
        }
        .padding()
        .offset(y: 120)
    }
    
    @ViewBuilder
    func NoResultsView() -> some View {
        VStack {
            Spacer()
            
            Image("no_results")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .offset(y: -100)
            
            Text("No events found.")
                .foregroundStyle(.white)
                .font(.title3)
                .offset(y: -130)
            
            Spacer()
        }
    }
}

#Preview {
    HomeView(showMenu: .constant(false), viewModel: HomeViewModel())
}
