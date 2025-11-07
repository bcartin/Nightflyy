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
    @State var isSearhing: Bool = false
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
                if viewModel.selectedSegment == 1 {
                    ForEach(viewModel.displayFollowers, id: \.self) { uid in
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
                    ForEach(viewModel.displayFollowing, id: \.self) { uid in
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
        
    }
    
}

#Preview {
    NetworkView(viewModel: NetworkViewModel(account: TestData.account, selectedSegment: 1))
        .preferredColorScheme(.dark)
}
