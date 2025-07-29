//
//  InviteToEventView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/17/25.
//

import SwiftUI

struct InviteToEventView: View {
    
    @Environment(Router.self) private var router
    @Environment(ToastsManager.self) private var toastsManager
    var viewModel: InviteToEventViewModel
    
    var body: some View {
        @Bindable var toastsManager = toastsManager
        
        ZStack(alignment: .bottom) {
            ScrollView {
                LazyVStack {
                    EventListView(header: "Hosting", viewModels: viewModel.futureHostingEvents)
                    EventListView(header: "Attending", viewModels: viewModel.attendingEvents)
                }
            }
            .scrollIndicators(.hidden)
            
            if !viewModel.selectedEvents.isEmpty {
                Button("Send Invites") {
                    viewModel.sendInvites()
                }
                .mainButtonStyle()
            }
            
        }
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Invite \(viewModel.accountToInvite.username ?? "To Event")")
                    .foregroundStyle(.white)
            }
        }
        .task {
            await viewModel.loadEvents()
        }
        .interactiveToast($toastsManager.toasts)
    }
    
    @ViewBuilder
    func EventListView(header: String, viewModels: [EventListItemViewModel]) -> some View {
        
        VStack(alignment: .leading) {
            Text(header.uppercased())
                .foregroundStyle(.white)
                .fontWeight(.medium)
            
            if viewModels.isEmpty {
                Text("No Events")
                    .foregroundStyle(.gray)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
            else {
                ForEach(viewModels, id: \.self) { viewModel in
                    LazyVStack {
                        EventListItemView(viewModel: viewModel) {
                                viewModel.markAsSelected()
                            self.viewModel.selectOrDeselectEvent(viewModel.event.uid)
                            }
                            .task {
                                await viewModel.fetchOwner()
                            }
                    }
                }
            }
            
        }
        .padding(.top, 8)
        .padding(.horizontal, 12)
        
    }
}

#Preview {
    InviteToEventView(viewModel: InviteToEventViewModel(accountToInvite: Account()))
}
