//
//  PromoCodeView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/27/25.
//

import SwiftUI

struct PromoCodeView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var viewModel: NFPSignUpViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Do you have a promo code?")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.vertical, 64)
            
            TextField("",
                      text: $viewModel.promoCodeCased,
                      prompt: Text("Promo Code")
                .foregroundStyle(.white.opacity(0.5)))
                .font(.system(size: 24))
                .multilineTextAlignment(.center)
            
            Rectangle()
                .foregroundStyle(.white.opacity(0.5))
                .frame(height: 1)
                .padding(.horizontal, 32)
            
            Text("Enter promo code to receive 1 Bonus Credit.")
                .font(.system(size: 14))
                .padding(.top)
                .padding(.bottom, 4)
            
            Text("Note: Bonus Credits are available after trial period completed.")
                .font(.system(size: 10))
            
            Spacer()
            
            Button("Redeem") {
                viewModel.validatePromoCode()
            }
            .mainButtonStyle()
            
            Button("Skip") {
                viewModel.changeView(to: .venueSelection)
            }
            .foregroundStyle(.mainPurple)
            .font(.system(size: 17))
            .padding()


        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
        .foregroundStyle(.white)
        .alert(isPresented: $viewModel.codeRedeemed, content: {
            CustomDialog(title: "Success!", content: "You will receive 1 Bonus Credit after your 7-Day Trial is completed.", button1: .init(content: "Continue", tint: .mainPurple, foreground: .white, action: { _ in
                viewModel.changeView(to: .venueSelection)
            }))
            .transition(.blurReplace.combined(with: .push(from: .bottom)))
        }, background: {
            Rectangle()
                .fill(.primary.opacity(0.35))
        })
        .gesture(
            DragGesture()
                .onChanged({ value in
                }).onEnded({ value in
                    if value.location.y - value.startLocation.y > 150 {
                        dismiss()
                    }
                })
        )
    }
}

#Preview {
    PromoCodeView(viewModel: .constant(NFPSignUpViewModel()))
}
