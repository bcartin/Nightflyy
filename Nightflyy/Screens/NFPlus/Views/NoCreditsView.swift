//
//  NoCreditsView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/12/25.
//

import SwiftUI

struct NoCreditsView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var viewModel: NFPRedeemViewModel
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 32) {
            
            Spacer()
                .frame(height: 72)
            
            Text("You've used all your\ncredits for this week")
                .foregroundStyle(.white)
                .font(.system(size: 20, weight: .medium))
            
            Image("plus_button_bw")
                .resizable()
                .frame(width: 200, height: 200)
            
            Text("Your next credit unlocks on Monday in:")
                .font(.system(size: 16))
                .foregroundColor(.white)
            
            HStack(alignment: .top) {
                VStack(spacing: 8) {
                    Text(String(format: "%02d", viewModel.day))
                        .font(.system(size: 32, weight: .bold))
                    Text("Days")
                        .font(.system(size: 18, weight: .bold))
                }
                
                colon
                
                VStack(spacing: 8) {
                    Text(String(format: "%02d", viewModel.hour))
                        .font(.system(size: 32, weight: .bold))
                    Text("Hours")
                        .font(.system(size: 18, weight: .bold))
                }
                
                colon
                
                VStack(spacing: 8) {
                    Text(String(format: "%02d", viewModel.minute))
                        .font(.system(size: 32, weight: .bold))
                    Text("Mins")
                        .font(.system(size: 18, weight: .bold))
                }
                
            }
            .foregroundColor(.white)
            
            Text("Want to explore the city while you wait?")
                .foregroundStyle(.white)
                .padding(.top, 48)
            
            Button {
                dismiss()
            } label: {
                Text("Browse Events")
                    .foregroundStyle(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 4)
                    .background(.clear)
                    .overlay(
                        Capsule()
                            .stroke(.mainPurple, lineWidth: 2)
                    )
                
            }

            
            Spacer()
            
        }
        .onReceive(timer) { _ in
            viewModel.updateTimer()
        }
    }
}

#Preview {
    MemberView()
}

extension NoCreditsView {
    private var colon: some View {
        Text(":")
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(.white)
    }
}
