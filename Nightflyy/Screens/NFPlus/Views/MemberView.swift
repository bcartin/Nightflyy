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
            
            HStack {
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "questionmark.circle.fill")
                        .foregroundStyle(.gray)
                        .font(.system(size: 24))
                        .padding()
                }
            }
            
            Spacer()
            
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
            }
            
            Spacer()
            
            Button("See All Nightflyy+ Venues") {
                
            }
            .foregroundStyle(.mainPurple)
            .font(.system(size: 14, weight: .medium))
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
        .overlay(alignment: .top) {
            RoundedRectangle(cornerRadius: 3)
                .fill(.gray.opacity(0.9))
                .frame(width: 86, height: 6)
        }
        .onChange(of: viewModel.shouldDismiss) { _, newValue in
            if newValue {
                dismiss()
            }
        }
        .errorAlert(error: $viewModel.error, buttonTitle: "OK")
    }
}

#Preview {
    MemberView()
}
