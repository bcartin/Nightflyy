//
//  VenueReferralView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/27/25.
//

import SwiftUI

struct VenueReferralView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var viewModel: NFPSignUpViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Who brought you to the Nightflyy+ club?")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 64)
                .padding(.bottom, 24)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.white.opacity(0.5))
                    .padding(.leading, 8)
                
                TextField("",
                          text: $viewModel.venueSearchText,
                          prompt: Text("Search for venue")
                    .foregroundStyle(.white.opacity(0.5)))
                .font(.system(size: 17))
            }
            .padding(.horizontal, 32)
            
            Rectangle()
                .foregroundStyle(.white.opacity(0.5))
                .frame(height: 1)
                .padding(.horizontal, 32)
                .padding(.bottom, 8)
            
            ScrollView(.vertical) {
                ForEach(viewModel.filteredNFPProviders) { account in
                    switch account.accountType {
                    case .personal:
                        PersonListItemView(viewModel: PersonListItemViewModel(account: account)) {
                            viewModel.referralVenue = account
                        }
                        .overlay {
                            if viewModel.showBorder(for: account) {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.mainPurple, lineWidth: 3)
                            }
                        }
                        .padding(.horizontal)
                    case .venue:
                        VenueListItemView(viewModel: VenueListItemViewModel(venue: account)) {
                            viewModel.referralVenue = account
                        }
                        .overlay {
                            if viewModel.showBorder(for: account) {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.mainPurple, lineWidth: 3)
                            }
                        }
                        .padding(.horizontal)
                    case .none:
                        EmptyView()
                    }
                }
            }
            
            Spacer()
            
            Button("Continue") {
                viewModel.changeView(to: .confirm)
            }
            .mainButtonStyle()
            
            Button("No one invited me to Nightflyy+") {
                viewModel.changeView(to: .confirm)
            }
            .foregroundStyle(.mainPurple)
            .font(.system(size: 17))
            .padding()


        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
        .foregroundStyle(.white)
        .gesture(
            DragGesture()
                .onChanged({ value in
                }).onEnded({ value in
                    if value.location.y - value.startLocation.y > 150 {
                        dismiss()
                    }
                })
        )
        .task {
            await viewModel.fetchNFPVenues()
        }
    }
}

#Preview {
    VenueReferralView(viewModel: .constant(NFPSignUpViewModel()))
}
