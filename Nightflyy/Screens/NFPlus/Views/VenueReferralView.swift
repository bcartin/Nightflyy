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
    @State var isTyping: Bool = false
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Who brought you to the Nightflyy+ club?")
                .font(.system(size: 18, weight: .bold))
                .padding(.top, 24)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                
                TextField("", text: $viewModel.venueSearchText, prompt: Text("Search").foregroundStyle(.white.opacity(0.5)))
                    .foregroundStyle(.white)
                    .padding(8)
                    .padding(.horizontal, 25)
                    .background(.gray.opacity(0.3))
                    .cornerRadius(8)
                    .onTapGesture {
                        self.isTyping = true
                    }
                    .overlay {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.white.opacity(0.5))
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                            
                            if isTyping {
                                Button(action: {
                                    viewModel.venueSearchText = ""
                                }, label: {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundStyle(.gray)
                                        .padding(.trailing, 12)
                                })
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
            
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
                viewModel.validateReferral()
            }
            .mainButtonStyle()

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
