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
        VStack(spacing: 44) {
            
            Text("🥂 Welcome to Nightflyy Plus!")
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
            
            UserImageRound(imageUrl: viewModel.referralVenue?.profileImageUrl, size: 150)
            
            Text("\(viewModel.referralVenue?.username ?? "") is letting you in the club!")
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
            
            Spacer()
                .frame(height: 64)
            
            let config = SlideToConfirm.Config(
                idleText: "Swipe to get in",
                onSwipeText: "Let's go!",
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
