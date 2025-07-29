//
//  InboxView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/22/24.
//

import SwiftUI

struct InboxView: View {
    
    @Binding var showMenu: Bool
    @Bindable var viewModel: InboxViewModel
    
    var body: some View {
        RouterView {
            List {
                ForEach(viewModel.viewModels) { chatViewModel in
                    InboxRowView(viewModel: chatViewModel) {
                        viewModel.navigateToChat(viewModel: chatViewModel)
                    }
                    .swipeActions {
                        Button {
                            chatViewModel.deleteChat()
                        } label: {
                            Text("Delete")
                        }
                        .tint(.red)
                    }
                    
                }
                
            }
            .listStyle(PlainListStyle())
            .frame(maxWidth: .infinity)
            .backgroundImage("slyde_background")
            .background(.backgroundBlack)
            .scrollIndicators(.hidden)
            .safeAreaPadding(.bottom, 44)
            .foregroundStyle(.white)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Inbox")
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
                        viewModel.shouldPresentNewChatView = true
                    }, label: {
                        Image(systemName:"square.and.pencil")
                            .foregroundStyle(.white)
                    })
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search")
            .sheet(isPresented: $viewModel.shouldPresentNewChatView) {
                NewChatView(viewModel: NewChatViewModel())
            }
        }
        
        
    }
}

#Preview {
    InboxView(showMenu: .constant(false), viewModel: InboxViewModel())
        .preferredColorScheme(.dark)
}
