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
    @FocusState private var isKeyboardActive: Bool
    
    var body: some View {
        VStack {
            
            if #available(iOS 26.0, *) { // TODO: Remove when min version is iOS 26
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.callout)
                        .foregroundStyle(.white.opacity(0.5))
                    
                    TextField("", text: $viewModel.searchText, prompt: Text("Search").foregroundStyle(.white.opacity(0.5)))
                        .submitLabel(.search)
                        .focused($isKeyboardActive)
                    
                    if !viewModel.searchText.isEmpty {
                        Button {
                            viewModel.searchText = ""
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
            }
            else {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.callout)
                        .foregroundStyle(.white.opacity(0.5))
                    
                    TextField("", text: $viewModel.searchText, prompt: Text("Search").foregroundStyle(.white.opacity(0.5)))
                        .submitLabel(.search)
                        .focused($isKeyboardActive)
                    
                    if !viewModel.searchText.isEmpty {
                        Button {
                            viewModel.searchText = ""
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
            
            SegmentedView(segments: viewModel.segments, selected: $viewModel.selectedSegment)
            
            ScrollView {
                
                ForEach(viewModel.displayArray, id: \.self) { uid in
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
            .scrollIndicators(.hidden)
        }
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
    }
}

#Preview {
    EventGuestListView(viewModel: EventGuestListViewModel(event: Event(), selectedSegment: 1))
}
