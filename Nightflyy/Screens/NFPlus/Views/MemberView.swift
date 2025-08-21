//
//  MemberView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/12/25.
//

import SwiftUI

struct MemberView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var viewModel: NFPRedeemViewModel = .init()
    
    var body: some View {
        VStack {
            
            switch viewModel.displayView {
            case .noCredits:
                NoCreditsView(viewModel: $viewModel)
            case .hasCredits:
                RedeemButtonView(viewModel: $viewModel)
                    .transition(.blurReplace)
            case .codeScreen:
                RedeemCodeView(viewModel: $viewModel)
                    .transition(.blurReplace)
            case .redeemSuccess:
                CreditRedeemedView(viewModel: $viewModel)
                    .transition(.blurReplace)
            case .venues:
                NFPVenuesView(viewModel: $viewModel)
            case .help:
                NFPHelpView(viewModel: $viewModel)
            }
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
        .overlay(alignment: .top) {
            HStack(alignment: .top) {
                Button {
                    switch viewModel.displayView {
                    case .hasCredits, .noCredits, .redeemSuccess:
                        dismiss()
                    case .codeScreen, .venues, .help:
                        viewModel.seeVenuesButtonIsVisible = true
                        viewModel.changeView(to: viewModel.mainDisplayView)
                    }
                } label: {
                    Image(systemName: "x.circle.fill")
                        .foregroundStyle(.gray)
                        .font(.system(size: 24))
                }
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 3)
                    .fill(.gray.opacity(0.9))
                    .frame(width: 86, height: 6)
                
                Spacer()
                
                Button {
                    viewModel.changeView(to: .help)
                } label: {
                    Image(systemName: "questionmark.circle.fill")
                        .foregroundStyle(.gray)
                        .font(.system(size: 24))
                }
            }
            .padding()
            
        }
        .overlay(alignment: .bottom, content: {
            Button("See All Nightflyy+ Venues") {
                viewModel.seeVenuesButtonIsVisible = false
                viewModel.changeView(to: .venues)
            }
            .foregroundStyle(.mainPurple)
            .font(.system(size: 14, weight: .medium))
            .padding()
            .opacity(viewModel.seeVenuesButtonIsVisible ? 1 : 0)
        })
        .task {
            await viewModel.fetchNFPVenues()
        }
        .errorAlert(error: $viewModel.error, buttonTitle: "OK")
    }
}

#Preview {
    MemberView()
}
