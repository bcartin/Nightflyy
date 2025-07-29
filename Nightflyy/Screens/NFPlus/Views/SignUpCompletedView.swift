//
//  SignUpCompletedView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/28/25.
//

import SwiftUI

struct SignUpCompletedView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var viewModel: NFPSignUpViewModel
    
    var body: some View {
        VStack(spacing: 48) {
            
            Spacer()
                .frame(height: 48)
            
            Text("You're all set!")
                .font(.system(size: 24, weight: .bold))
            
            Image("ConfirmationCheck")
                .resizable()
                .frame(width: 128, height: 128)
            
            Text("Welcome to Nightflyy\(viewModel.isSigningUp ? "" : "+")!")
                .font(.system(size: 24, weight: .bold))
            
            Spacer()
            
            Button(viewModel.isSigningUp ? "Get Started" : "Continue") {
                viewModel.finishSignUp()
                dismiss()
            }
            .mainButtonStyle()
            .padding(.bottom, 32)
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
    SignUpCompletedView(viewModel: .constant(NFPSignUpViewModel()))
}
