//
//  ConfirmNFPView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 7/28/25.
//

import SwiftUI

struct ConfirmNFPView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var viewModel: NFPSignUpViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            
            Image("plus_button")
                .resizable()
                .frame(width: 150, height: 150)
                .padding(.bottom, 32)
            
            Text("Almost there. Swipe below to subscribe to Nightflyy+ and get a 7 day trial!")
                .font(.system(size: 17))
                .multilineTextAlignment(.center)
            
            Text("$7.99/month after trial period. You can cancel anytime.")
                .font(.system(size: 11))
                .multilineTextAlignment(.center)
            
            Spacer()
                .frame(height: 64)
            
            let config = SlideToConfirm.Config(
                idleText: "Swipe to Subscribe",
                onSwipeText: "Subscription Confirmed",
                confirmationText: "Success!",
                tint: .mainPurple,
                foregorundColor: .white
            )
            
            SlideToConfirm(config: config) {
                viewModel.purchaseNightFlyyPlus()
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
    }
}

#Preview {
    ConfirmNFPView(viewModel: .constant(.init()))
}
